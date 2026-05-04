//
// FIDO2 Example
//
// Copyright © 2026 Nevis Security AG. All rights reserved.
//

import AuthenticationServices

/// A thin subclass of `ASAuthorizationController` that carries the originating
/// ``StartAuthorizationResponse`` and the auto-fill flag through the delegate lifecycle.
///
/// It acts as the bridge between the domain layer (use cases / options) and the
/// AuthenticationServices framework. Factory methods translate ``AuthorizationCreationOption``
/// into the appropriate `ASAuthorizationRequest` subclass.
final class AuthorizationController: ASAuthorizationController {
	/// The server response that describes the type and parameters of the current ceremony.
	let startAuthorizationResponse: StartAuthorizationResponse
	/// `true` when the request should use QuickType bar auto-fill instead of the modal sheet.
	let isAutoFillAssisted: Bool

	/// Creates an `AuthorizationController` configured for the given authorization response.
	///
	/// - Parameters:
	///   - startAuthorizationResponse: The server response describing the type and options for the ceremony.
	///   - isAutoFillAssisted: Pass `true` to use QuickType bar auto-fill instead of the modal sheet.
	/// - Throws: ``AppError/invalidConversion(message:underlying:)`` if the challenge or userId data is missing.
	/// - Returns: An `AuthorizationController` instance configured with the appropriate request, or `nil` if the response type is unsupported.
	init?(startAuthorizationResponse: StartAuthorizationResponse, isAutoFillAssisted: Bool) throws {
		self.startAuthorizationResponse = startAuthorizationResponse
		self.isAutoFillAssisted = isAutoFillAssisted
		try super.init(authorizationRequests: [Self.createAuthorizationRequest(with: startAuthorizationResponse)])
	}
}

private extension AuthorizationController {
	/// Routes the response to the correct request factory based on its type.
	///
	/// - Parameter response: The ``StartAuthorizationResponse`` to convert.
	/// - Throws: ``AppError/invalidConversion`` if required fields are missing, or a `fatalError` for unsupported cases.
	/// - Returns: An `ASAuthorizationRequest` for the appropriate ceremony type.
	static func createAuthorizationRequest(with response: StartAuthorizationResponse) throws -> some ASAuthorizationRequest {
		switch response {
			case let .credentialRegistration(username, _, authorizationCreationOption):
				try createCredentialRegistrationRequest(username: username, options: authorizationCreationOption)
			case let .credentialAssertion(_, authorizationCreationOption):
				try createCredentialAuthenticationRequest(options: authorizationCreationOption)
			default:
				fatalError("Invalid authorization request.")
		}
	}
}

// MARK: - Registration

private extension AuthorizationController {
	/// Creates a platform (Face ID / Touch ID) or cross-platform (security key) registration
	/// request depending on the ``AuthorizationCreationOption/authenticatorAttachment`` value.
	///
	/// - Throws: ``AppError/invalidConversion`` if `challenge` or `userId` are missing.
	/// - Returns: An `ASAuthorizationRequest` instance configured for the appropriate registration type.
	static func createCredentialRegistrationRequest(username: String, options: AuthorizationCreationOption) throws -> some ASAuthorizationRequest {
		guard let challenge = options.challenge,
			let userId = options.userId
		else {
			throw AppError.invalidConversion(message: "Invalid challenge or userId when creating credential registration request for authorization.")
		}

		return if options.authenticatorAttachment == .crossPlatform {
			createCrossPlatformSpecificRequest(username: username, challenge: challenge, userId: userId, options: options)
		} else {
			createPlatformSpecificRequest(username: username, challenge: challenge, userId: userId, options: options)
		}
	}

	/// Creates a platform-authenticator (Face ID / Touch ID) credential registration request.
	///
	/// - Parameters:
	///   - username: The display name and account name for the credential.
	///   - challenge: The server-generated challenge bytes.
	///   - userId: The user handle bytes.
	///   - options: Additional FIDO2 options (attestation, user verification, exclude list).
	/// - Returns: A configured `ASAuthorizationPlatformPublicKeyCredentialRegistrationRequest`.
	static func createPlatformSpecificRequest(username: String, challenge: Data, userId: Data, options: AuthorizationCreationOption) -> some ASAuthorizationRequest {
		let provider = ASAuthorizationPlatformPublicKeyCredentialProvider(relyingPartyIdentifier: options.rpId)
		let registrationRequest = provider.createCredentialRegistrationRequest(
			challenge: challenge,
			name: username,
			userID: userId,
		)

		registrationRequest.displayName = username
		if let attestationPreference = options.attestationPreference {
			registrationRequest.attestationPreference = ASAuthorizationPublicKeyCredentialAttestationKind(rawValue: attestationPreference.rawValue)
		}
		if let userVerificationPreference = options.userVerificationPreference {
			registrationRequest.userVerificationPreference = ASAuthorizationPublicKeyCredentialUserVerificationPreference(rawValue: userVerificationPreference.rawValue)
		}
		if #available(iOS 17.4, *) {
			registrationRequest.excludedCredentials = options.excludeCredentials?.map { ASAuthorizationPlatformPublicKeyCredentialDescriptor(credentialID: $0) }
		}

		return registrationRequest
	}

	/// Creates a cross-platform (security key) credential registration request.
	///
	/// - Parameters:
	///   - username: The display name and account name for the credential.
	///   - challenge: The server-generated challenge bytes.
	///   - userId: The user handle bytes.
	///   - options: Additional FIDO2 options (attestation, user verification, resident key, credential parameters, exclude list).
	/// - Returns: A configured `ASAuthorizationSecurityKeyPublicKeyCredentialRegistrationRequest`.
	static func createCrossPlatformSpecificRequest(username: String, challenge: Data, userId: Data, options: AuthorizationCreationOption) -> some ASAuthorizationRequest {
		let provider = ASAuthorizationSecurityKeyPublicKeyCredentialProvider(relyingPartyIdentifier: options.rpId)
		let registrationRequest = provider.createCredentialRegistrationRequest(
			challenge: challenge,
			displayName: username,
			name: username,
			userID: userId,
		)

		if let attestationPreference = options.attestationPreference {
			registrationRequest.attestationPreference = ASAuthorizationPublicKeyCredentialAttestationKind(rawValue: attestationPreference.rawValue)
		}
		if let userVerificationPreference = options.userVerificationPreference {
			registrationRequest.userVerificationPreference = ASAuthorizationPublicKeyCredentialUserVerificationPreference(rawValue: userVerificationPreference.rawValue)
		}
		if let credentialParameters = options.pubKeyCredParams {
			registrationRequest.credentialParameters = credentialParameters.map { ASAuthorizationPublicKeyCredentialParameters(algorithm: ASCOSEAlgorithmIdentifier(rawValue: $0)) }
		}
		if let residentKeyPreference = options.residentKeyPreference {
			registrationRequest.residentKeyPreference = ASAuthorizationPublicKeyCredentialResidentKeyPreference(rawValue: residentKeyPreference.rawValue)
		}
		if #available(iOS 17.4, *) {
			if let excludeCredentials = options.excludeCredentials {
				registrationRequest.excludedCredentials = excludeCredentials.map { credential in
					ASAuthorizationSecurityKeyPublicKeyCredentialDescriptor(credentialID: credential, transports: [.usb, .bluetooth, .nfc])
				}
			}
		}

		return registrationRequest
	}
}

// MARK: - Authentication

private extension AuthorizationController {
	/// Creates an assertion request for passkey-based authentication.
	///
	/// If `allowCredentials` is populated the system will filter available passkeys to
	/// that list; otherwise all discoverable credentials for the RP are eligible.
	///
	/// - Throws: ``AppError/invalidConversion`` if the `challenge` is missing.
	/// - Returns: A configured `ASAuthorizationPlatformPublicKeyCredentialAssertionRequest`.
	static func createCredentialAuthenticationRequest(options: AuthorizationCreationOption) throws -> some ASAuthorizationRequest {
		guard let challenge = options.challenge else {
			throw AppError.invalidConversion(message: "Invalid challenge when creating credential authentication request for authorization.")
		}

		let publicKeyCredentialProvider = ASAuthorizationPlatformPublicKeyCredentialProvider(relyingPartyIdentifier: options.rpId)
		let assertionRequest = publicKeyCredentialProvider.createCredentialAssertionRequest(challenge: challenge)

		if let userVerificationPreference = options.userVerificationPreference {
			assertionRequest.userVerificationPreference = ASAuthorizationPublicKeyCredentialUserVerificationPreference(rawValue: userVerificationPreference.rawValue)
		}
		if let allowCredentials = options.allowCredentials {
			assertionRequest.allowedCredentials = allowCredentials.map { ASAuthorizationPlatformPublicKeyCredentialDescriptor(credentialID: $0) }
		}

		return assertionRequest
	}
}

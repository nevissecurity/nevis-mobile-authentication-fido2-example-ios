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
	let startAuthorizationResponse: StartAuthorizationResponse
	let isAutoFillAssisted: Bool

	init?(startAuthorizationResponse: StartAuthorizationResponse, isAutoFillAssisted: Bool) throws {
		self.startAuthorizationResponse = startAuthorizationResponse
		self.isAutoFillAssisted = isAutoFillAssisted
		try super.init(authorizationRequests: [Self.createAuthorizationRequest(with: startAuthorizationResponse)])
	}
}

private extension AuthorizationController {
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
	static func createCredentialRegistrationRequest(username: String, options: AuthorizationCreationOption) throws -> some ASAuthorizationRequest {
		guard let challenge = options.challenge,
		      let userId = options.userId
		else {
			throw AppError.invalidConversion(message: "Invalid challenge or userId when creating credential registration request for authorization.")
		}

		return if options.authenticatorAttachment == .crossPlatform {
			createCrossPlatformSpecificRequest(username: username, challenge: challenge, userId: userId, options: options)
		}
		else {
			createPlatformSpecificRequest(username: username, challenge: challenge, userId: userId, options: options)
		}
	}

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

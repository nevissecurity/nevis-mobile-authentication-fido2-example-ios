//
// FIDO2 Example App
//
// Copyright © 2025 Nevis Security AG. All rights reserved.
//

import AuthenticationServices

struct RegistrationResponse: ServerResponse {
	var errorMessage: String?
	var status: String?

	let userId: String
	let username: String
	let authenticators: Set<String>
	let enrollment: Enrollment
}

// MARK: - Map to domain

extension RegistrationResponse {
	func toDomain(username: String) -> Result<StartAuthorizationResponse, AppError> {
		if isError {
			return .failure(AppError.request(message: errorMessage))
		}

		let credentialCreationOptions = enrollment.credentialCreationOptions
		guard let challengeData = credentialCreationOptions.challenge.base64UrlDecodedData,
		      let userIdData = credentialCreationOptions.user.id.base64UrlDecodedData
		else {
			return .failure(.invalidConversion())
		}

		let registrationRequest = switch credentialCreationOptions.authenticatorSelection.authenticatorAttachment {
		case .platform, .none:
			createPlatformSpecificRequest(challengeData: challengeData, userIdData: userIdData)
		case .crossPlatform:
			createCrossPlatformSpecificRequest(challengeData: challengeData, userIdData: userIdData)
		}

		return .success(StartAuthorizationResponse(asAuthorizationRequest: registrationRequest, statusToken: enrollment.statusToken, username: username))
	}
}

private extension RegistrationResponse {
	func createPlatformSpecificRequest(challengeData: Data, userIdData: Data) -> some ASAuthorizationRequest {
		let credentialCreationOptions = enrollment.credentialCreationOptions
		let provider = ASAuthorizationPlatformPublicKeyCredentialProvider(relyingPartyIdentifier: credentialCreationOptions.rp.id)

		let registrationRequest = provider.createCredentialRegistrationRequest(
			challenge: challengeData,
			name: username,
			userID: userIdData,
		)

		registrationRequest.attestationPreference = ASAuthorizationPublicKeyCredentialAttestationKind(rawValue: credentialCreationOptions.attestation)
		if let userVerification = credentialCreationOptions.authenticatorSelection.userVerification {
			registrationRequest.userVerificationPreference = ASAuthorizationPublicKeyCredentialUserVerificationPreference(rawValue: userVerification.rawValue)
		}
		if #available(iOS 17.4, *) {
			registrationRequest.excludedCredentials = credentialCreationOptions.excludeCredentials.map { element in
				ASAuthorizationPlatformPublicKeyCredentialDescriptor(credentialID: element.id.base64UrlDecodedData!)
			}
		}

		return registrationRequest
	}

	func createCrossPlatformSpecificRequest(challengeData: Data, userIdData: Data) -> some ASAuthorizationRequest {
		let credentialCreationOptions = enrollment.credentialCreationOptions
		let provider = ASAuthorizationSecurityKeyPublicKeyCredentialProvider(relyingPartyIdentifier: credentialCreationOptions.rp.id)

		let registrationRequest = provider.createCredentialRegistrationRequest(
			challenge: challengeData,
			displayName: username,
			name: username,
			userID: userIdData,
		)

		registrationRequest.attestationPreference = ASAuthorizationPublicKeyCredentialAttestationKind(rawValue: credentialCreationOptions.attestation)
		if let userVerification = credentialCreationOptions.authenticatorSelection.userVerification {
			registrationRequest.userVerificationPreference = ASAuthorizationPublicKeyCredentialUserVerificationPreference(rawValue: userVerification.rawValue)
		}
		registrationRequest.credentialParameters = credentialCreationOptions.pubKeyCredParams.map { credential in
			ASAuthorizationPublicKeyCredentialParameters(algorithm: ASCOSEAlgorithmIdentifier(rawValue: credential.alg))
		}
		if let residentKey = credentialCreationOptions.authenticatorSelection.residentKey {
			registrationRequest.residentKeyPreference = ASAuthorizationPublicKeyCredentialResidentKeyPreference(rawValue: residentKey.rawValue)
		}
		if #available(iOS 17.4, *) {
			registrationRequest.excludedCredentials = credentialCreationOptions.excludeCredentials.map { element in
				ASAuthorizationSecurityKeyPublicKeyCredentialDescriptor(credentialID: element.id.base64UrlDecodedData!, transports: [.usb, .bluetooth, .nfc])
			}
		}

		return registrationRequest
	}
}

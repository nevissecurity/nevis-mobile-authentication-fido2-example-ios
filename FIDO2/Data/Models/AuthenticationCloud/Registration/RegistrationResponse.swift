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
		let provider = ASAuthorizationPlatformPublicKeyCredentialProvider(relyingPartyIdentifier: credentialCreationOptions.rp.id)

		guard let challengeData = credentialCreationOptions.challenge.base64UrlDecodedData,
		      let userIdData = credentialCreationOptions.user.id.base64UrlDecodedData
		else {
			return .failure(.invalidConversion())
		}

		let registrationRequest = provider.createCredentialRegistrationRequest(
			challenge: challengeData,
			name: username,
			userID: userIdData,
		)

		registrationRequest.attestationPreference = ASAuthorizationPublicKeyCredentialAttestationKind(rawValue: credentialCreationOptions.attestation)
		registrationRequest.userVerificationPreference = ASAuthorizationPublicKeyCredentialUserVerificationPreference(rawValue: credentialCreationOptions.authenticatorSelection.userVerification.rawValue)
		if #available(iOS 17.4, *) {
			registrationRequest.excludedCredentials = credentialCreationOptions.excludeCredentials.map { element in
				ASAuthorizationPlatformPublicKeyCredentialDescriptor(credentialID: element.id.base64UrlDecodedData!)
			}
		}

		return .success(StartAuthorizationResponse(asAuthorizationRequest: registrationRequest, statusToken: enrollment.statusToken, username: username))
	}
}

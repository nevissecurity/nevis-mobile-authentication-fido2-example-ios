//
// FIDO2 Example App
//
// Copyright © 2025 Nevis Security AG. All rights reserved.
//

import AuthenticationServices

struct ApprovalResponse: ServerResponse {
	var errorMessage: String?
	var status: String?

	let transactionId: String
	var userId: String?
	let statusToken: String
	let credentialRequestOptions: CredentialRequestOptions
}

// MARK: - Map to domain

extension ApprovalResponse {
	func toDomain(username: String? = nil) -> Result<StartAuthorizationResponse, AppError> {
		if isError {
			return .failure(AppError.request(message: errorMessage))
		}

		guard let challengeData = credentialRequestOptions.challenge.base64UrlDecodedData else {
			return .failure(.invalidConversion())
		}

		let publicKeyCredentialProvider = ASAuthorizationPlatformPublicKeyCredentialProvider(relyingPartyIdentifier: credentialRequestOptions.rpId)
		let assertionRequest = publicKeyCredentialProvider.createCredentialAssertionRequest(challenge: challengeData)

		assertionRequest.userVerificationPreference = ASAuthorizationPublicKeyCredentialUserVerificationPreference(rawValue: credentialRequestOptions.userVerification.rawValue)
		if let allowCredentials = credentialRequestOptions.allowCredentials {
			assertionRequest.allowedCredentials = allowCredentials.map { element in ASAuthorizationPlatformPublicKeyCredentialDescriptor(credentialID: element.id.base64UrlDecodedData!) }
		}

		return .success(StartAuthorizationResponse(asAuthorizationRequest: assertionRequest, statusToken: statusToken, username: username))
	}
}

//
// FIDO2 Example
//
// Copyright © 2025 Nevis Security AG. All rights reserved.
//

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
	func map(username: String? = nil) -> Result<StartAuthorizationResponse, AppError> {
		if isError {
			return .failure(AppError.request(message: errorMessage))
		}

		let authorizationCreationOptions = AuthorizationCreationOption(
			rpId: credentialRequestOptions.rpId,
			username: username,
			challenge: credentialRequestOptions.challenge.base64UrlDecodedData,
			userVerificationPreference: credentialRequestOptions.userVerification.map(),
			allowCredentials: credentialRequestOptions.allowCredentials?.compactMap(\.id.base64UrlDecodedData)
		)

		return .success(.credentialAssertion(statusToken: statusToken, authorizationCreationOption: authorizationCreationOptions))
	}
}

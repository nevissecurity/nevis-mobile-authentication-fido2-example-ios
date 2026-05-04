//
// FIDO2 Example
//
// Copyright © 2026 Nevis Security AG. All rights reserved.
//

/// DTO for the `POST /api/v1/approval` response containing the credential request options
/// needed to drive the passkey assertion.
struct ApprovalResponse: ServerResponse {
	var errorMessage: String?
	var status: String?

	/// The server-side transaction identifier for this authentication session.
	let transactionId: String
	/// The user identifier associated with the authentication attempt, or `nil` for usernameless flows.
	var userId: String?
	/// The opaque token required to complete the authentication ceremony.
	let statusToken: String
	/// The WebAuthn credential request options needed to drive the passkey assertion.
	let credentialRequestOptions: CredentialRequestOptions
}

// MARK: - Map to domain

extension ApprovalResponse {
	/// Maps this response to a domain ``StartAuthorizationResponse``.
	///
	/// - Parameter username: The username associated with the authentication attempt, or `nil` for usernameless flows.
	/// - Returns: `.success` with a `.credentialAssertion` response, or `.failure` with an ``AppError`` if the server returned an error.
	func map(username: String? = nil) -> Result<StartAuthorizationResponse, AppError> {
		if isError {
			return .failure(AppError.request(message: errorMessage))
		}

		let authorizationCreationOptions = AuthorizationCreationOption(
			rpId: credentialRequestOptions.rpId,
			username: username,
			challenge: credentialRequestOptions.challenge.base64UrlDecodedData,
			userVerificationPreference: credentialRequestOptions.userVerification.map(),
			allowCredentials: credentialRequestOptions.allowCredentials?.compactMap(\.id.base64UrlDecodedData),
		)

		return .success(.credentialAssertion(statusToken: statusToken, authorizationCreationOption: authorizationCreationOptions))
	}
}

//
// FIDO2 Example
//
// Copyright © 2026 Nevis Security AG. All rights reserved.
//

/// DTO for the `POST /_app/attestation/result` response containing the JWT authorization token.
struct AttestationResponse: ServerResponse {
	var errorMessage: String?
	var status: String?

	/// The JWT authorization token returned by the server after successful registration.
	let token: String
}

// MARK: - Map to domain

extension AttestationResponse {
	/// Maps this response to a domain ``AuthorizationToken``.
	///
	/// - Returns: `.success` wrapping the JWT token string, or `.failure` with an ``AppError`` if the server returned an error.
	func map() -> Result<AuthorizationToken, Error> {
		if isError {
			return .failure(AppError.request(message: errorMessage))
		}

		return .success(token)
	}
}

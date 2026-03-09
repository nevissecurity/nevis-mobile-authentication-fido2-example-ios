//
// FIDO2 Example
//
// Copyright © 2026 Nevis Security AG. All rights reserved.
//

/// DTO for the `POST /_app/assertion/result` response containing the JWT authorization token.
struct AssertionResponse: ServerResponse {
	var errorMessage: String?
	var status: String?

	let token: String
}

// MARK: - Map to domain

extension AssertionResponse {
	func map() -> Result<AuthorizationToken, Error> {
		if isError {
			return .failure(AppError.request(message: errorMessage))
		}

		return .success(token)
	}
}

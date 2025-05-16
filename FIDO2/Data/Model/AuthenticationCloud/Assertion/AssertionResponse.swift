//
// FIDO2 Example
//
// Copyright © 2025 Nevis Security AG. All rights reserved.
//

struct AssertionResponse: ServerResponse {
	var errorMessage: String?
	var status: String?

	let token: String
}

// MARK: - Map to domain

extension AssertionResponse {
	func map() -> Result<(), Error> {
		if isError {
			return .failure(AppError.request(message: errorMessage))
		}

		return .success(())
	}
}

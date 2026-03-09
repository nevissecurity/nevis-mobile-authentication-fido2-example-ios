//
// FIDO2 Example
//
// Copyright © 2026 Nevis Security AG. All rights reserved.
//

/// DTO for the error payload returned by the Authentication Cloud when an API call fails.
struct ErrorResponse: Decodable {
	let error: String
	let message: String?
	let status: Int
}

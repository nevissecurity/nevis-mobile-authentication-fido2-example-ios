//
// FIDO2 Example
//
// Copyright © 2026 Nevis Security AG. All rights reserved.
//

/// DTO for the error payload returned by the Authentication Cloud when an API call fails.
struct ErrorResponse: Decodable {
	/// The short machine-readable error code (e.g. `"invalid_request"`).
	let error: String
	/// A human-readable description of the error, if provided by the server.
	let message: String?
	/// The HTTP status code included in the response body.
	let status: Int
}

//
// FIDO2 Example
//
// Copyright © 2026 Nevis Security AG. All rights reserved.
//

/// Common protocol adopted by all Authentication Cloud response DTOs.
///
/// Provides a unified way to detect API-level errors before mapping to domain types.
protocol ServerResponse: Decodable {
	/// The server-returned error message, or `nil` if the response indicates success.
	var errorMessage: String? { get }
	/// An optional status string from the server response body.
	var status: String? { get }
}

extension ServerResponse {
	/// `true` if the response contains a non-empty error message, indicating an API-level error.
	var isError: Bool {
		!(errorMessage?.isEmpty ?? true)
	}
}

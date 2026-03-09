//
// FIDO2 Example
//
// Copyright © 2026. Nevis Security AG. All rights reserved.
//

/// DTO for the `POST /api/v1/introspect` request body (form-encoded).
///
/// Note: the filename contains a known typo (`IntroscpectRequest`) — do not rename.
struct IntrospectRequest: Encodable {
	let token: String
}

// MARK: - IntrospectRequest + DictionaryConvertible

extension IntrospectRequest {
	var asDictionary: [String: String] {
		[
			"token": token,
		]
	}
}

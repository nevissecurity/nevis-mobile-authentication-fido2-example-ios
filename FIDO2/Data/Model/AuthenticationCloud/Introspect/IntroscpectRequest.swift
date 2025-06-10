//
// FIDO2 Example
//
// Copyright © 2025. Nevis Security AG. All rights reserved.
//

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

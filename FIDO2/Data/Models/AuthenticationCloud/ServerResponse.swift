//
// FIDO2 Example
//
// Copyright © 2025 Nevis Security AG. All rights reserved.
//

protocol ServerResponse: Decodable {
	var errorMessage: String? { get }
	var status: String? { get }
}

extension ServerResponse {
	var isError: Bool {
		!(errorMessage?.isEmpty ?? true)
	}
}

//
// FIDO2 Example
//
// Copyright © 2026 Nevis Security AG. All rights reserved.
//

/// A descriptor for a public key credential, used in allow/exclude credential lists.
struct Credential: Codable {
	let type: String
	let id: String
}

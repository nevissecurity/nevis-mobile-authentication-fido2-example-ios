//
// FIDO2 Example
//
// Copyright © 2026 Nevis Security AG. All rights reserved.
//

/// A descriptor for a public key credential, used in allow/exclude credential lists.
struct Credential: Codable {
	/// The credential type. Always `"public-key"` per the WebAuthn spec.
	let type: String
	/// The Base64URL-encoded credential identifier.
	let id: String
}

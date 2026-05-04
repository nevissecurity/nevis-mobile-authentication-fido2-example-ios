//
// FIDO2 Example
//
// Copyright © 2026 Nevis Security AG. All rights reserved.
//

/// Describes an acceptable public key algorithm for credential creation.
///
/// Corresponds to the WebAuthn `PublicKeyCredentialParameters` structure.
struct PubKeyCredParam: Codable {
	/// The COSE algorithm identifier (e.g. `-7` for ES256, `-257` for RS256).
	let alg: Int
	/// The credential type, always `"public-key"` per the WebAuthn spec.
	let type: String
}

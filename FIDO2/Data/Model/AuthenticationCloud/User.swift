//
// FIDO2 Example
//
// Copyright © 2026 Nevis Security AG. All rights reserved.
//

/// DTO representing the user account in a WebAuthn credential creation ceremony.
struct User: Codable {
	/// The human-readable display name shown in authenticator and account selection UI.
	let displayName: String
	/// The user handle (Base64URL-encoded bytes) used to identify the account internally.
	let id: String
	/// The account name (typically the username or email address).
	let name: String
}

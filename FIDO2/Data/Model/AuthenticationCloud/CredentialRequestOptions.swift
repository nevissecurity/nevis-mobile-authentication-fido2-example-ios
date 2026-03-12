//
// FIDO2 Example
//
// Copyright © 2026 Nevis Security AG. All rights reserved.
//

/// DTO representing the WebAuthn `PublicKeyCredentialRequestOptions` returned by the server
/// during the authentication ceremony (from `/api/v1/approval`).
struct CredentialRequestOptions: Codable {
	/// The relying party identifier used to look up matching credentials on the authenticator.
	let rpId: String
	/// The user verification requirement for the assertion ceremony.
	let userVerification: UserVerification
	/// The time limit in milliseconds the client is allowed to wait for authenticator interaction.
	let timeout: Int
	/// The Base64URL-encoded challenge bytes that must be signed by the authenticator.
	let challenge: String
	/// Credential IDs the authenticator is allowed to use, or `nil` for any credential.
	var allowCredentials: [Credential]?
}

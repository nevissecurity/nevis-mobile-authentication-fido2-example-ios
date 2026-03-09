//
// FIDO2 Example
//
// Copyright © 2026 Nevis Security AG. All rights reserved.
//

/// DTO representing the WebAuthn `PublicKeyCredentialRequestOptions` returned by the server
/// during the authentication ceremony (from `/api/v1/approval`).
struct CredentialRequestOptions: Codable {
	let rpId: String
	let userVerification: UserVerification
	let timeout: Int
	let challenge: String
	var allowCredentials: [Credential]?
}

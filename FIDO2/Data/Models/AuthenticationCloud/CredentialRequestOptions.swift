//
// FIDO2 Example App
//
// Copyright © 2025 Nevis Security AG. All rights reserved.
//

struct CredentialRequestOptions: Codable {
	let rpId: String
	let userVerification: Fido2UserVerification
	let timeout: Int
	let challenge: String
	var allowCredentials: [Credential]?
}

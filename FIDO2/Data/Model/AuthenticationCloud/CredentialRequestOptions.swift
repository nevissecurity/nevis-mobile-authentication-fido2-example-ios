//
// FIDO2 Example
//
// Copyright © 2025 Nevis Security AG. All rights reserved.
//

struct CredentialRequestOptions: Codable {
	let rpId: String
	let userVerification: UserVerification
	let timeout: Int
	let challenge: String
	var allowCredentials: [Credential]?
}

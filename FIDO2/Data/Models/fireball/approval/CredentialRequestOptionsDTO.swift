//
// FIDO2 PoC
//
// Copyright © 2025 NEVIS. All rights reserved.
//

struct CredentialRequestOptionsDTO: Decodable {
	let rpId: String
	let userVerification: Fido2UserVerificationDTO
	let timeout: Int
	let challenge: String
	let allowCredentials: [CredentialDTO]
}

//
// FIDO2 PoC
//
// Copyright © 2025 NEVIS. All rights reserved.
//

struct AuthenticatorSelection: Codable {
	let requireResidentKey: Bool
	let residentKey: String
	let userVerification: Fido2UserVerification
}

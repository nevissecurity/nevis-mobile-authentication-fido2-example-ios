//
// FIDO2 Example App
//
// Copyright © 2025 Nevis Security AG. All rights reserved.
//

struct AuthenticatorSelection: Codable {
	let requireResidentKey: Bool
	let residentKey: String
	let userVerification: Fido2UserVerification
}

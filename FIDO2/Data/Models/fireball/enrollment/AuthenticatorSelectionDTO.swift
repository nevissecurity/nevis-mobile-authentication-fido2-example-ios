//
// FIDO2 PoC
//
// Copyright © 2025 NEVIS. All rights reserved.
//

struct AuthenticatorSelectionDTO: Codable {
	let requireResidentKey: Bool
	let residentKey: String
	let userVerification: Fido2UserVerificationDTO
}

extension AuthenticatorSelectionDTO {
	func toDomain() -> AuthenticatorSelection {
		AuthenticatorSelection(
			requireResidentKey: requireResidentKey,
			residentKey: residentKey,
			userVerification: userVerification.toDomain()
		)
	}
}

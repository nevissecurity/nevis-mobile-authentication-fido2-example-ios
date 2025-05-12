//
// FIDO2 Example App
//
// Copyright © 2025 Nevis Security AG. All rights reserved.
//

struct RegistrationFido2Options: Codable {
	var authenticatorSelection: AuthenticatorSelection?
	var attestation: Attestation?
}

extension RegistrationFido2Options {
	init?(from entity: Fido2Options?) {
		guard let entity else { return nil }

		let authenticatorAttachment: AuthenticatorAttachment? = AuthenticatorAttachment(from: entity.authenticatorAttachment)
		let userVerification: UserVerification? = UserVerification(from: entity.userVerificationRequirement)
		let residentKey: ResidentKey? = ResidentKey(from: entity.residentKeyRequirement)

		if authenticatorAttachment != nil || userVerification != nil || residentKey != nil {
			self.authenticatorSelection = AuthenticatorSelection(
				authenticatorAttachment: authenticatorAttachment,
				userVerification: userVerification,
				residentKey: residentKey
			)
		}
		self.attestation = Attestation(from: entity.requirementConveyancePreference)
	}
}

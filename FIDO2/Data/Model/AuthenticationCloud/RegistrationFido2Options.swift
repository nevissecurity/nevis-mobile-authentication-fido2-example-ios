//
// FIDO2 Example
//
// Copyright © 2025 Nevis Security AG. All rights reserved.
//

struct RegistrationFido2Options: Codable {
	var authenticatorSelection: AuthenticatorSelection?
	var attestation: Attestation?
}

// MARK: - Mapping

extension RegistrationFido2Options {
	// MARK: - From Domain

	static func map(from options: Fido2Options?) -> RegistrationFido2Options? {
		guard let options else { return nil }

		let authenticatorAttachment: AuthenticatorAttachment? = .map(from: options.authenticatorAttachment)
		let userVerification: UserVerification? = .map(from: options.userVerificationRequirement)
		let residentKey: ResidentKey? = .map(from: options.residentKeyRequirement)

		var authenticatorSelection: AuthenticatorSelection?
		if authenticatorAttachment != nil || userVerification != nil || residentKey != nil {
			authenticatorSelection = .init(
				authenticatorAttachment: authenticatorAttachment,
				userVerification: userVerification,
				residentKey: residentKey,
			)
		}

		return .init(
			authenticatorSelection: authenticatorSelection,
			attestation: .map(from: options.attestationConveyancePreference),
		)
	}
}

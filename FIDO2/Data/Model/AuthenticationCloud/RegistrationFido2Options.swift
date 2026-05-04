//
// FIDO2 Example
//
// Copyright © 2026 Nevis Security AG. All rights reserved.
//

/// DTO for the optional FIDO2 policy options sent with a registration request.
struct RegistrationFido2Options: Codable {
	/// The authenticator selection criteria to include in the registration request, or `nil` to use server defaults.
	var authenticatorSelection: AuthenticatorSelection?
	/// The attestation conveyance preference to include in the registration request, or `nil` to use the server default.
	var attestation: Attestation?
}

// MARK: - Mapping

extension RegistrationFido2Options {
	// MARK: - From Domain

	/// Creates a ``RegistrationFido2Options`` from the given domain ``Fido2Options``.
	///
	/// Maps authenticator attachment, user verification, resident key, and attestation fields.
	///
	/// - Parameter options: The domain options to convert, or `nil` to indicate no options.
	/// - Returns: A populated ``RegistrationFido2Options``, or `nil` if `options` is `nil`.
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

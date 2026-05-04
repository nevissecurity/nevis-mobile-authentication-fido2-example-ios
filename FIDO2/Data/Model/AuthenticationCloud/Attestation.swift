//
// FIDO2 Example
//
// Copyright © 2026 Nevis Security AG. All rights reserved.
//

/// DTO enum for the WebAuthn `attestation` conveyance preference field.
///
/// One-way mapping from the domain ``Fido2AttestationConveyancePreference`` (used when building requests).
enum Attestation: String, Codable {
	/// No attestation data is conveyed.
	case none
	/// The authenticator may replace the attestation statement with an anonymisation CA.
	case indirect
	/// The full attestation statement is requested from the authenticator.
	case direct
}

// MARK: - Map from Domain

extension Attestation? {
	/// Creates an ``Attestation`` value from a domain ``Fido2AttestationConveyancePreference``.
	///
	/// - Parameter entity: The domain preference to convert, or `nil` to indicate no preference.
	/// - Returns: The corresponding ``Attestation`` case, or `nil` if the input is `nil` or unrecognised.
	static func map(from entity: Fido2AttestationConveyancePreference?) -> Attestation? {
		switch entity {
			case .none?:
				Attestation.none
			case .indirect:
				.indirect
			case .direct:
				.direct
			default:
				nil
		}
	}
}

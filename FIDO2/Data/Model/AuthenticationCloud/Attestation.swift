//
// FIDO2 Example
//
// Copyright © 2026 Nevis Security AG. All rights reserved.
//

/// DTO enum for the WebAuthn `attestation` conveyance preference field.
///
/// One-way mapping from the domain ``Fido2AttestationConveyancePreference`` (used when building requests).
enum Attestation: String, Codable {
	case none
	case indirect
	case direct
}

// MARK: - Map from Domain

extension Attestation? {
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

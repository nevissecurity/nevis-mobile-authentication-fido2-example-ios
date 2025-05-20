//
// FIDO2 Example
//
// Copyright © 2025 Nevis Security AG. All rights reserved.
//

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

//
// FIDO2 Example App
//
// Copyright © 2025 Nevis Security AG. All rights reserved.
//

enum Attestation: String, Codable {
	case none
	case indirect
	case direct
}

// MARK: - From domain

extension Attestation {
	init?(from entity: Fido2RequirementConveyancePreference?) {
		guard let entity else { return nil }

		switch entity {
		case .none:
			self = .none
		case .indirect:
			self = .indirect
		case .direct:
			self = .direct
		default:
			return nil
		}
	}
}

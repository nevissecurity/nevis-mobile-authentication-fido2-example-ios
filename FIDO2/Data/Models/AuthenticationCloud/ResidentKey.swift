//
// FIDO2 Example App
//
// Copyright © 2025 Nevis Security AG. All rights reserved.
//

enum ResidentKey: String, Codable {
	case preferred
	case required
	case discouraged
}

// MARK: - From domain

extension ResidentKey {
	init?(from entity: Fido2RequirementOption?) {
		guard let entity else { return nil }

		switch entity {
		case .preferred:
			self = .preferred
		case .required:
			self = .required
		case .discouraged:
			self = .discouraged
		default:
			return nil
		}
	}
}

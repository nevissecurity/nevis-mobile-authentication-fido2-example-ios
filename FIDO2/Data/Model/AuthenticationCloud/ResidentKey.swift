//
// FIDO2 Example
//
// Copyright © 2025 Nevis Security AG. All rights reserved.
//

enum ResidentKey: String, Codable {
	case preferred
	case required
	case discouraged
}

// MARK: - Mapping

extension ResidentKey {
	// MARK: From Domain

	static func map(from entity: Fido2RequirementOption?) -> ResidentKey? {
		switch entity {
		case .preferred:
			.preferred
		case .required:
			.required
		case .discouraged:
			.discouraged
		default:
			nil
		}
	}

	// MARK: To Domain

	func map() -> Fido2RequirementOption {
		switch self {
		case .preferred:
			.preferred
		case .required:
			.required
		case .discouraged:
			.discouraged
		}
	}
}

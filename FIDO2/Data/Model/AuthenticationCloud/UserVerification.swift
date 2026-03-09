//
// FIDO2 Example
//
// Copyright © 2026 Nevis Security AG. All rights reserved.
//

/// DTO enum for the WebAuthn `userVerification` field, used in server request/response DTOs.
///
/// Bidirectional mapping between this DTO type and the domain ``Fido2RequirementOption``.
enum UserVerification: String, Codable {
	case preferred
	case required
	case discouraged
}

// MARK: - Mapping

extension UserVerification {
	// MARK: From Domain

	static func map(from entity: Fido2RequirementOption?) -> UserVerification? {
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

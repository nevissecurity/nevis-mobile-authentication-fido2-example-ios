//
// FIDO2 Example
//
// Copyright © 2026 Nevis Security AG. All rights reserved.
//

/// DTO enum for the WebAuthn `userVerification` field, used in server request/response DTOs.
///
/// Bidirectional mapping between this DTO type and the domain ``Fido2RequirementOption``.
enum UserVerification: String, Codable {
	/// The server prefers but does not require user verification.
	case preferred
	/// The server requires user verification.
	case required
	/// The server prefers user verification not be used.
	case discouraged
}

// MARK: - Mapping

extension UserVerification {
	// MARK: From Domain

	/// Creates a ``UserVerification`` from the corresponding domain ``Fido2RequirementOption``.
	///
	/// - Parameter entity: The domain requirement option, or `nil` to indicate no preference.
	/// - Returns: The matching DTO case, or `nil` if `entity` is `nil` or unmapped.
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

	/// Maps this DTO value to the corresponding domain ``Fido2RequirementOption``.
	///
	/// - Returns: The matching domain case.
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

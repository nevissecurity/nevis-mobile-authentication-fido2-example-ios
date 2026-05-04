//
// FIDO2 Example
//
// Copyright © 2026 Nevis Security AG. All rights reserved.
//

/// DTO enum for the WebAuthn `residentKey` field, used in server request/response DTOs.
///
/// Bidirectional mapping between this DTO type and the domain ``Fido2RequirementOption``.
enum ResidentKey: String, Codable {
	/// The server prefers but does not require discoverable credentials.
	case preferred
	/// The server requires discoverable credentials.
	case required
	/// The server prefers discoverable credentials not be used.
	case discouraged
}

// MARK: - Mapping

extension ResidentKey {
	// MARK: From Domain

	/// Creates a ``ResidentKey`` from the corresponding domain ``Fido2RequirementOption``.
	///
	/// - Parameter entity: The domain requirement option, or `nil` to indicate no preference.
	/// - Returns: The matching DTO case, or `nil` if `entity` is `nil` or unmapped.
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

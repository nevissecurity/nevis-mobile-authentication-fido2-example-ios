//
// FIDO2 Example
//
// Copyright © 2026 Nevis Security AG. All rights reserved.
//

/// DTO enum for the WebAuthn `authenticatorAttachment` field.
///
/// Bidirectional mapping between this DTO type and the domain ``Fido2AuthenticatorAttachment``.
enum AuthenticatorAttachment: String, Codable {
	/// A platform authenticator (Touch ID, Face ID) bound to the current device.
	case platform
	/// A roaming authenticator, such as a hardware security key.
	case crossPlatform = "cross-platform"
}

// MARK: - Mapping

extension AuthenticatorAttachment {
	// MARK: From Domain

	/// Creates an ``AuthenticatorAttachment`` from the corresponding domain entity.
	///
	/// - Parameter entity: The domain authenticator attachment value, or `nil`.
	/// - Returns: The matching DTO case, or `nil` if `entity` is `nil` or unmapped.
	static func map(from entity: Fido2AuthenticatorAttachment?) -> AuthenticatorAttachment? {
		switch entity {
			case .platform:
				.platform
			case .crossPlatform:
				.crossPlatform
			default:
				nil
		}
	}

	// MARK: To Domain

	/// Maps this DTO value to the corresponding domain ``Fido2AuthenticatorAttachment``.
	///
	/// - Returns: The matching domain case.
	func map() -> Fido2AuthenticatorAttachment {
		switch self {
			case .platform:
				.platform
			case .crossPlatform:
				.crossPlatform
		}
	}
}

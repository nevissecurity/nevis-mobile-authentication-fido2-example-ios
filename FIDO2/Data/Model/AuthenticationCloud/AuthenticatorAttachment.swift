//
// FIDO2 Example
//
// Copyright © 2025 Nevis Security AG. All rights reserved.
//

enum AuthenticatorAttachment: String, Codable {
	case platform
	case crossPlatform = "cross-platform"
}

// MARK: - Mapping

extension AuthenticatorAttachment {
	// MARK: From Domain

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

	func map() -> Fido2AuthenticatorAttachment {
		switch self {
		case .platform:
			.platform
		case .crossPlatform:
			.crossPlatform
		}
	}
}

//
// FIDO2 Example App
//
// Copyright © 2025 Nevis Security AG. All rights reserved.
//

enum AuthenticatorAttachment: String, Codable {
	case platform
	case crossPlatform = "cross-platform"
}

// MARK: - From domain

extension AuthenticatorAttachment {
	init?(from entity: Fido2AuthenticatorAttachment?) {
		guard let entity else { return nil }

		switch entity {
		case .platform:
			self = .platform
		case .crossPlatform:
			self = .crossPlatform
		default:
			return nil
		}
	}
}

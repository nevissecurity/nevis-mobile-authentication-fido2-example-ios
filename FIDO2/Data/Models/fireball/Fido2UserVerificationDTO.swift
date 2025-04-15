//
// FIDO2 PoC
//
// Copyright © 2025 NEVIS. All rights reserved.
//

enum Fido2UserVerificationDTO: String, Codable {
	case preferred
	case required
	case discouraged
}

extension Fido2UserVerificationDTO {
	func toDomain() -> Fido2UserVerification {
		switch self {
		case .preferred:
			return .preferred
		case .required:
			return .required
		case .discouraged:
			return .discouraged
		}
	}
}

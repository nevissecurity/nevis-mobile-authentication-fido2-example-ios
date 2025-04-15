//
// FIDO2 PoC
//
// Copyright © 2025 NEVIS. All rights reserved.
//

enum Fido2UserVerification: String, Codable {
	case preferred
	case required
	case discouraged
}

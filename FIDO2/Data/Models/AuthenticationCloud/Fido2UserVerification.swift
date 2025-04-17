//
// FIDO2 Example App
//
// Copyright © 2025 Nevis Security AG. All rights reserved.
//

enum Fido2UserVerification: String, Codable {
	case preferred
	case required
	case discouraged
}

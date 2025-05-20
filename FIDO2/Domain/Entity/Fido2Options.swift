//
// FIDO2 Example
//
// Copyright © 2025 Nevis Security AG. All rights reserved.
//

struct Fido2Options {
	var userVerificationRequirement: Fido2RequirementOption?
	var authenticatorAttachment: Fido2AuthenticatorAttachment?
	var attestationConveyancePreference: Fido2AttestationConveyancePreference?
	var residentKeyRequirement: Fido2RequirementOption?
}

enum Fido2RequirementOption: String, Equatable {
	case required
	case preferred
	case discouraged
}

enum Fido2AuthenticatorAttachment: String, Equatable {
	case platform
	case crossPlatform = "cross-platform"
}

enum Fido2AttestationConveyancePreference: String, Equatable {
	case none
	case indirect
	case direct
}

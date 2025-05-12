//
// FIDO2 Example
//
// Copyright © 2025 Nevis Security AG. All rights reserved.
//

struct Fido2Options {
	var requirementConveyancePreference: Fido2RequirementConveyancePreference?
	var authenticatorAttachment: Fido2AuthenticatorAttachment?
	var userVerificationRequirement: Fido2RequirementOption?
	var residentKeyRequirement: Fido2RequirementOption?
}

enum Fido2RequirementOption: String, CaseIterable, Equatable, Identifiable {
	var id: Self { self }

	case unspecified = "Unspecified"
	case required = "Required"
	case preferred = "Preferred"
	case discouraged = "Discouraged"
}

enum Fido2AuthenticatorAttachment: String, CaseIterable, Equatable, Identifiable {
	var id: Self { self }

	case unspecified = "Unspecified"
	case platform = "Platform"
	case crossPlatform = "Cross-Platform"
}

enum Fido2RequirementConveyancePreference: String, CaseIterable, Equatable, Identifiable {
	var id: Self { self }

	case unspecified = "Unspecified"
	case none = "None"
	case indirect = "Indirect"
	case direct = "Direct"
}

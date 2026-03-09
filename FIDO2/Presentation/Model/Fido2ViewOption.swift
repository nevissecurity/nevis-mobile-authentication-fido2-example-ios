//
// FIDO2 Example
//
// Copyright © 2026 Nevis Security AG. All rights reserved.
//

/// View-layer representation of a FIDO2 requirement (user verification or resident key).
///
/// `unspecified` is the "use server default" state. Maps to ``Fido2RequirementOption`` via
/// `Fido2RequirementOption.map(from:)`.
enum Fido2RequirementViewOption: String, CaseIterable, Equatable, Identifiable {
	var id: Self { self }

	case unspecified = "Unspecified"
	case required = "Required"
	case preferred = "Preferred"
	case discouraged = "Discouraged"
}

/// View-layer representation of the authenticator attachment preference.
///
/// `unspecified` means no constraint. Maps to ``Fido2AuthenticatorAttachment`` via
/// `Fido2AuthenticatorAttachment.map(from:)`.
enum Fido2AuthenticatorAttachmentViewOption: String, CaseIterable, Equatable, Identifiable {
	var id: Self { self }

	case unspecified = "Unspecified"
	case platform = "Platform"
	case crossPlatform = "Cross-Platform"
}

/// View-layer representation of the attestation conveyance preference.
///
/// `unspecified` means use server default. Maps to ``Fido2AttestationConveyancePreference`` via
/// `Fido2AttestationConveyancePreference.map(from:)`.
enum Fido2AttestationConveyancePreferenceViewOption: String, CaseIterable, Equatable, Identifiable {
	var id: Self { self }

	case unspecified = "Unspecified"
	case none = "None"
	case indirect = "Indirect"
	case direct = "Direct"
}

// MARK: - Map to Domain

extension Fido2Options {
	static func map(from options: (Fido2RequirementViewOption, Fido2AuthenticatorAttachmentViewOption, Fido2AttestationConveyancePreferenceViewOption, Fido2RequirementViewOption)) -> Fido2Options {
		.init(
			userVerificationRequirement: .map(from: options.0),
			authenticatorAttachment: .map(from: options.1),
			attestationConveyancePreference: .map(from: options.2),
			residentKeyRequirement: .map(from: options.3),
		)
	}

	static func map(from userVerificationRequirement: Fido2RequirementViewOption) -> Fido2Options {
		.init(
			userVerificationRequirement: .map(from: userVerificationRequirement),
		)
	}
}

extension Fido2RequirementOption {
	static func map(from viewModel: Fido2RequirementViewOption) -> Fido2RequirementOption? {
		switch viewModel {
		case .required:
			.required
		case .preferred:
			.preferred
		case .discouraged:
			.discouraged
		default:
			nil
		}
	}
}

extension Fido2AuthenticatorAttachment {
	static func map(from viewModel: Fido2AuthenticatorAttachmentViewOption) -> Fido2AuthenticatorAttachment? {
		switch viewModel {
		case .platform:
			.platform
		case .crossPlatform:
			.crossPlatform
		default:
			nil
		}
	}
}

extension Fido2AttestationConveyancePreference {
	static func map(from viewModel: Fido2AttestationConveyancePreferenceViewOption) -> Fido2AttestationConveyancePreference? {
		switch viewModel {
		case .none:
			Fido2AttestationConveyancePreference.none
		case .indirect:
			.indirect
		case .direct:
			.direct
		default:
			nil
		}
	}
}

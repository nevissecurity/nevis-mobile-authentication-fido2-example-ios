//
// FIDO2 Example
//
// Copyright © 2025 Nevis Security AG. All rights reserved.
//

extension HomeScreenViewModel {
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
}

// MARK: - Map to Domain

extension Fido2Options {
	static func map(from options: (HomeScreenViewModel.Fido2RequirementOption, HomeScreenViewModel.Fido2AuthenticatorAttachment, HomeScreenViewModel.Fido2RequirementConveyancePreference, HomeScreenViewModel.Fido2RequirementOption)) -> Fido2Options {
		.init(
			userVerificationRequirement: .map(from: options.0),
			authenticatorAttachment: .map(from: options.1),
			requirementConveyancePreference: .map(from: options.2),
			residentKeyRequirement: .map(from: options.3)
		)
	}

	static func map(from userVerificationRequirement: HomeScreenViewModel.Fido2RequirementOption) -> Fido2Options {
		.init(
			userVerificationRequirement: .map(from: userVerificationRequirement),
		)
	}
}

extension Fido2RequirementOption {
	static func map(from viewModel: HomeScreenViewModel.Fido2RequirementOption) -> Fido2RequirementOption? {
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
	static func map(from viewModel: HomeScreenViewModel.Fido2AuthenticatorAttachment) -> Fido2AuthenticatorAttachment? {
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

extension Fido2RequirementConveyancePreference {
	static func map(from viewModel: HomeScreenViewModel.Fido2RequirementConveyancePreference) -> Fido2RequirementConveyancePreference? {
		switch viewModel {
		case .none:
			Fido2RequirementConveyancePreference.none
		case .indirect:
			.indirect
		case .direct:
			.direct
		default:
			nil
		}
	}
}

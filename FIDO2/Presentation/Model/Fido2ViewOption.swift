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

	/// No preference; the server default is used.
	case unspecified = "Unspecified"
	/// The operation is mandatory.
	case required = "Required"
	/// The operation is preferred but not mandatory.
	case preferred = "Preferred"
	/// The operation should be avoided if possible.
	case discouraged = "Discouraged"
}

/// View-layer representation of the authenticator attachment preference.
///
/// `unspecified` means no constraint. Maps to ``Fido2AuthenticatorAttachment`` via
/// `Fido2AuthenticatorAttachment.map(from:)`.
enum Fido2AuthenticatorAttachmentViewOption: String, CaseIterable, Equatable, Identifiable {
	var id: Self { self }

	/// No attachment constraint; any authenticator may be used.
	case unspecified = "Unspecified"
	/// Use a platform authenticator (Touch ID, Face ID).
	case platform = "Platform"
	/// Use a roaming authenticator (e.g. a hardware security key).
	case crossPlatform = "Cross-Platform"
}

/// View-layer representation of the attestation conveyance preference.
///
/// `unspecified` means use server default. Maps to ``Fido2AttestationConveyancePreference`` via
/// `Fido2AttestationConveyancePreference.map(from:)`.
enum Fido2AttestationConveyancePreferenceViewOption: String, CaseIterable, Equatable, Identifiable {
	var id: Self { self }

	/// No preference; the server default is used.
	case unspecified = "Unspecified"
	/// No attestation data is requested.
	case none = "None"
	/// Anonymised attestation via an anonymisation CA.
	case indirect = "Indirect"
	/// Full attestation from the authenticator is requested.
	case direct = "Direct"
}

// MARK: - Map to Domain

extension Fido2Options {
	/// Creates a ``Fido2Options`` from the full set of view-layer option selections.
	///
	/// - Parameter options: A tuple of (userVerification, authenticatorAttachment, attestationConveyancePreference, residentKey) view options.
	/// - Returns: A ``Fido2Options`` with all four fields mapped to their domain equivalents.
	static func map(from options: (Fido2RequirementViewOption, Fido2AuthenticatorAttachmentViewOption, Fido2AttestationConveyancePreferenceViewOption, Fido2RequirementViewOption)) -> Fido2Options {
		.init(
			userVerificationRequirement: .map(from: options.0),
			authenticatorAttachment: .map(from: options.1),
			attestationConveyancePreference: .map(from: options.2),
			residentKeyRequirement: .map(from: options.3),
		)
	}

	/// Creates a ``Fido2Options`` containing only the user verification requirement.
	///
	/// Convenience factory used by the authentication (non-registration) flow.
	///
	/// - Parameter userVerificationRequirement: The selected user verification view option.
	/// - Returns: A ``Fido2Options`` with only `userVerificationRequirement` set.
	static func map(from userVerificationRequirement: Fido2RequirementViewOption) -> Fido2Options {
		.init(
			userVerificationRequirement: .map(from: userVerificationRequirement),
		)
	}
}

extension Fido2RequirementOption {
	/// Maps a ``Fido2RequirementViewOption`` to the domain ``Fido2RequirementOption``.
	///
	/// - Parameter viewModel: The view-layer option to convert.
	/// - Returns: The matching domain case, or `nil` if the input is `.unspecified`.
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
	/// Maps a ``Fido2AuthenticatorAttachmentViewOption`` to the domain ``Fido2AuthenticatorAttachment``.
	///
	/// - Parameter viewModel: The view-layer option to convert.
	/// - Returns: The matching domain case, or `nil` if the input is `.unspecified`.
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
	/// Maps a ``Fido2AttestationConveyancePreferenceViewOption`` to the domain ``Fido2AttestationConveyancePreference``.
	///
	/// - Parameter viewModel: The view-layer option to convert.
	/// - Returns: The matching domain case, or `nil` if the input is `.unspecified`.
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

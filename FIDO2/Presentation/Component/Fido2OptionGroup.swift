//
// FIDO2 Example
//
// Copyright © 2026 Nevis Security AG. All rights reserved.
//

import SwiftUI

/// A collapsible `DisclosureGroup` that exposes the four FIDO2 policy option pickers.
///
/// When `isRegistration` is `true`, the authenticator attachment, attestation conveyance
/// preference, and resident key pickers are also shown. Some pickers are disabled when
/// the authenticator attachment is not set to `.crossPlatform` because those options only
/// apply to roaming authenticators.
struct Fido2OptionGroup: View {
	// MARK: Properties

	/// When `true`, additional registration-specific pickers (authenticator attachment, attestation, resident key) are shown.
	let isRegistration: Bool

	/// Whether the FIDO2 options `DisclosureGroup` is currently expanded.
	@Binding var isExpanded: Bool
	/// The currently selected user verification requirement.
	@Binding var userVerificationRequirement: Fido2RequirementViewOption
	/// The currently selected authenticator attachment constraint.
	@Binding var authenticatorAttachment: Fido2AuthenticatorAttachmentViewOption
	/// The currently selected attestation conveyance preference.
	@Binding var attestationConveyancePreference: Fido2AttestationConveyancePreferenceViewOption
	/// The currently selected resident key requirement.
	@Binding var residentKeyRequirement: Fido2RequirementViewOption

	// MARK: View

	var body: some View {
		DisclosureGroup(
			isExpanded: $isExpanded,
			content: {
				VStack {
					Divider()
						.padding(.top, 10)
					if isRegistration {
						optionPicker(title: "Authenticator Attachment", selection: $authenticatorAttachment)
					}
					optionPicker(title: "User Verification Requirement", selection: $userVerificationRequirement, isDisabled: isRegistration && authenticatorAttachment != .crossPlatform)
					if isRegistration {
						optionPicker(title: "Attestation Conveyance Preference", selection: $attestationConveyancePreference, isDisabled: authenticatorAttachment != .crossPlatform)
						optionPicker(title: "Resident Key Requirement", selection: $residentKeyRequirement, isDisabled: authenticatorAttachment != .crossPlatform)
					}
				}
			},
			label: {
				Text("Options")
					.optionGroupLabel()
			},
		)
		.fido2OptionGroup()
	}

	/// Creates a labelled `Picker` for a `CaseIterable` option type with optional disabling.
	///
	/// - Parameters:
	///   - title: The label shown above the segmented picker.
	///   - selection: Binding to the currently selected option.
	///   - isDisabled: When `true`, the picker is rendered but non-interactive.
	/// - Returns: A `VStack` containing the title label and a segmented `Picker`.
	func optionPicker<T: Hashable & CaseIterable & RawRepresentable>(title: String, selection: Binding<T>, isDisabled: Bool = false) -> some View where T.RawValue == String {
		VStack(alignment: .leading) {
			Text(title)
				.optionTitle()
				.padding(.top, 5)
			Picker(title, selection: selection) {
				ForEach(Array(T.allCases), id: \.self) { option in
					Text(option.rawValue)
						.optionLabel()
						.tag(option)
				}
			}
			.disabled(isDisabled)
			.pickerStyle(.segmented)
		}
	}
}

// MARK: - Preview

@available(iOS 17.0, *)
#Preview("Registration") {
	@Previewable @State var isExpanded = true
	@Previewable @State var userVerificationRequirement: Fido2RequirementViewOption = .unspecified
	@Previewable @State var authenticatorAttachment: Fido2AuthenticatorAttachmentViewOption = .unspecified
	@Previewable @State var attestationConveyancePreference: Fido2AttestationConveyancePreferenceViewOption = .unspecified
	@Previewable @State var residentKeyRequirement: Fido2RequirementViewOption = .unspecified
	Fido2OptionGroup(
		isRegistration: true,
		isExpanded: $isExpanded,
		userVerificationRequirement: $userVerificationRequirement,
		authenticatorAttachment: $authenticatorAttachment,
		attestationConveyancePreference: $attestationConveyancePreference,
		residentKeyRequirement: $residentKeyRequirement,
	)
}

@available(iOS 17.0, *)
#Preview("Authentication") {
	@Previewable @State var isExpanded = true
	@Previewable @State var userVerificationRequirement: Fido2RequirementViewOption = .unspecified
	@Previewable @State var authenticatorAttachment: Fido2AuthenticatorAttachmentViewOption = .unspecified
	@Previewable @State var attestationConveyancePreference: Fido2AttestationConveyancePreferenceViewOption = .unspecified
	@Previewable @State var residentKeyRequirement: Fido2RequirementViewOption = .unspecified
	Fido2OptionGroup(
		isRegistration: false,
		isExpanded: $isExpanded,
		userVerificationRequirement: $userVerificationRequirement,
		authenticatorAttachment: $authenticatorAttachment,
		attestationConveyancePreference: $attestationConveyancePreference,
		residentKeyRequirement: $residentKeyRequirement,
	)
}

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
///
/// Note: the filename contains a known capitalisation typo (`FIdo2`) — do not rename.
struct FIdo2OptionGroup: View {
	// MARK: Properties

	let isRegistration: Bool

	@Binding var isExpanded: Bool
	@Binding var userVerificationRequirement: Fido2RequirementViewOption
	@Binding var authenticatorAttachment: Fido2AuthenticatorAttachmentViewOption
	@Binding var attestationConveyancePreference: Fido2AttestationConveyancePreferenceViewOption
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
	FIdo2OptionGroup(
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
	FIdo2OptionGroup(
		isRegistration: false,
		isExpanded: $isExpanded,
		userVerificationRequirement: $userVerificationRequirement,
		authenticatorAttachment: $authenticatorAttachment,
		attestationConveyancePreference: $attestationConveyancePreference,
		residentKeyRequirement: $residentKeyRequirement,
	)
}

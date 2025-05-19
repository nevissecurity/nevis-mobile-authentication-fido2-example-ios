//
// FIDO2 Example
//
// Copyright © 2025 Nevis Security AG. All rights reserved.
//

import SwiftUI

struct FIdo2OptionGroup: View {
	// MARK: Properties

	let isRegistration: Bool

	@Binding var isExpanded: Bool
	@Binding var userVerificationRequirement: Fido2RequirementViewOption
	@Binding var authenticatorAttachment: Fido2AuthenticatorAttachmentViewOption
	@Binding var requirementConveyancePreference: Fido2RequirementConveyancePreferenceViewOption
	@Binding var residentKeyRequirement: Fido2RequirementViewOption

	// MARK: View

	var body: some View {
		DisclosureGroup(
			isExpanded: $isExpanded,
			content: {
				VStack {
					Divider()
						.padding(.top, 10)
					optionPicker(title: "User Verification Requirement", selection: $userVerificationRequirement)
					if isRegistration {
						optionPicker(title: "Authenticator Attachment", selection: $authenticatorAttachment)
						optionPicker(title: "Attestation Conveyance Preference", selection: $requirementConveyancePreference, isDisabled: authenticatorAttachment != .crossPlatform)
						optionPicker(title: "Resident Key Requirement", selection: $residentKeyRequirement, isDisabled: authenticatorAttachment != .crossPlatform)
					}
				}
			},
			label: {
				Text("Options")
					.optionGroupLabel()
			}
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
#Preview() {
	@Previewable @State var isExpanded = true
	@Previewable @State var userVerificationRequirement: Fido2RequirementViewOption = .unspecified
	@Previewable @State var authenticatorAttachment: Fido2AuthenticatorAttachmentViewOption = .unspecified
	@Previewable @State var requirementConveyancePreference: Fido2RequirementConveyancePreferenceViewOption = .unspecified
	@Previewable @State var residentKeyRequirement: Fido2RequirementViewOption = .unspecified
	FIdo2OptionGroup(
		isRegistration: true,
		isExpanded: $isExpanded,
		userVerificationRequirement: $userVerificationRequirement,
		authenticatorAttachment: $authenticatorAttachment,
		requirementConveyancePreference: $requirementConveyancePreference,
		residentKeyRequirement: $residentKeyRequirement
	)
}

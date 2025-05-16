//
// FIDO2 Example
//
// Copyright © 2025 Nevis Security AG. All rights reserved.
//

import SwiftUI

extension HomeScreenView {
	func options(for section: HomeScreenViewModel.Section) -> some View {
		DisclosureGroup(content: {
			VStack {
				Divider()
					.padding(.top, 10)

				fido2OptionTitle("User Verification Requirement")
				Picker("User Verification Requirement", selection: $viewModel.userVerificationRequirement) {
					ForEach(HomeScreenViewModel.Fido2RequirementOption.allCases, id: \.self) { option in
						fido2OptionLabel(option.rawValue).tag(option)
					}
				}
				.pickerStyle(.segmented)

				if section.id == .register {
					fido2OptionTitle("Authenticator Attachment")
					Picker("Authenticator Attachment", selection: $viewModel.authenticatorAttachment) {
						ForEach(HomeScreenViewModel.Fido2AuthenticatorAttachment.allCases, id: \.self) { attachment in
							fido2OptionLabel(attachment.rawValue).tag(attachment)
						}
					}
					.pickerStyle(.segmented)

					fido2OptionTitle("Attestation Conveyance Preference")
					Picker("Resident Key Requirement", selection: $viewModel.requirementConveyancePreference) {
						ForEach(HomeScreenViewModel.Fido2RequirementConveyancePreference.allCases, id: \.self) { preference in
							fido2OptionLabel(preference.rawValue).tag(preference)
						}
					}
					.disabled($viewModel.authenticatorAttachment.wrappedValue != .crossPlatform)
					.pickerStyle(.segmented)

					fido2OptionTitle("Resident Key Requirement")
					Picker("Resident Key Requirement", selection: $viewModel.residentKeyRequirement) {
						ForEach(HomeScreenViewModel.Fido2RequirementOption.allCases, id: \.self) { option in
							fido2OptionLabel(option.rawValue).tag(option)
						}
					}
					.disabled($viewModel.authenticatorAttachment.wrappedValue != .crossPlatform)
					.pickerStyle(.segmented)
				}
			}
		}, label: {
			Text("Options")
				.font(.subheadline)
				.foregroundColor(.secondary)
		})
		.accentColor(.secondary)
		.padding(10)
		.background(
			RoundedRectangle(cornerRadius: 10)
				.stroke(Color(.separator), lineWidth: 1)
				.background(Color(.systemGray5).cornerRadius(10))
		)
		.padding(.bottom, 10)
	}

	func fido2OptionTitle(_ title: String) -> some View {
		Text(title)
			.font(.caption)
			.foregroundColor(.secondary)
			.frame(maxWidth: .infinity, alignment: .leading)
			.padding(.top, 5)
	}

	func fido2OptionLabel(_ label: String) -> some View {
		Text(label)
			.font(.caption)
	}
}

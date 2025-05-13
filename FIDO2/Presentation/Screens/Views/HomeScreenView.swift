//
// FIDO2 Example App
//
// Copyright © 2025 Nevis Security AG. All rights reserved.
//

import SwiftUI
import SwinjectAutoregistration

struct HomeScreenView: View {
	enum FocusedField {
		case username
	}

	// MARK: Properties

	@EnvironmentObject private var viewModel: HomeScreenViewModel
	@FocusState private var focusedField: FocusedField?

	// MARK: Body

	var body: some View {
		LoadingView(isShowing: $viewModel.isLoading) {
			GeometryReader { geometry in
				ScrollView {
					VStack {
						Text("FIDO 2 Example")
							.font(.title)
							.padding(.bottom, 30)

						usernameField
						fido2Options
						buttons

						Spacer()
						message
							.animation(.easeInOut, value: viewModel.message == nil)

						Spacer()
						appConfiguration
					}
					.padding()
					.frame(minHeight: geometry.size.height)
				}
			}
		}
		.onAppear {
			focusedField = .username
		}
		.onTapGesture {
			focusedField = nil
		}
	}

	// MARK: Components

	var usernameField: some View {
		TextField("Username", text: $viewModel.username, prompt: Text("Enter username"))
			.textContentType(.username)
			.textInputAutocapitalization(.never)
			.disableAutocorrection(true)
			.textFieldStyle(.roundedBorder)
			.focused($focusedField, equals: .username)
			.overlay {
				HStack {
					Spacer()
					Image(systemName: "person.badge.key")
						.resizable()
						.frame(width: 20, height: 20)
						.foregroundColor(.accentColor)
						.opacity(viewModel.isAutoFillAssistedReady ? 1 : 0)
						.padding(.trailing, 10)
						.animation(.easeInOut, value: viewModel.isAutoFillAssistedReady)
				}
			}
			.padding(.bottom, 10)
	}

	var fido2Options: some View {
		DisclosureGroup(content: {
			VStack {
				Divider()
					.padding(.top, 10)

				fido2OptionTitle("(Reg.) Attestation Conveyance Preference")
				Picker("Resident Key Requirement", selection: $viewModel.requirementConveyancePreference) {
					ForEach(Fido2RequirementConveyancePreference.allCases, id: \.self) { preference in
						fido2OptionLabel(preference.rawValue).tag(preference)
					}
				}
				.pickerStyle(.segmented)

				fido2OptionTitle("(Reg.) Authenticator Attachment")
				Picker("Authenticator Attachment", selection: $viewModel.authenticatorAttachment) {
					ForEach(Fido2AuthenticatorAttachment.allCases, id: \.self) { attachment in
						fido2OptionLabel(attachment.rawValue).tag(attachment)
					}
				}
				.pickerStyle(.segmented)

				fido2OptionTitle("(Reg./Auth.) User Verification Requirement")
				Picker("User Verification Requirement", selection: $viewModel.userVerificationRequirement) {
					ForEach(Fido2RequirementOption.allCases, id: \.self) { option in
						fido2OptionLabel(option.rawValue).tag(option)
					}
				}
				.pickerStyle(.segmented)

				fido2OptionTitle("(Reg.) Resident Key Requirement")
					.disabled($viewModel.authenticatorAttachment.wrappedValue != .crossPlatform)
				Picker("Resident Key Requirement", selection: $viewModel.residentKeyRequirement) {
					ForEach(Fido2RequirementOption.allCases, id: \.self) { option in
						fido2OptionLabel(option.rawValue).tag(option)
					}
				}
				.disabled($viewModel.authenticatorAttachment.wrappedValue != .crossPlatform)
				.pickerStyle(.segmented)
			}
		}, label: {
			Text("Registration / Authentication  Options")
				.font(.subheadline)
				.foregroundColor(.secondary)
		})
		.accentColor(.secondary)
		.padding(10)
		.background(
			RoundedRectangle(cornerRadius: 10)
				.stroke(Color(.separator), lineWidth: 1)
				.background(Color(.secondarySystemBackground).cornerRadius(10))
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

	var buttons: some View {
		ForEach($viewModel.buttons, id: \.self) { button in
			Button(action: {
				print("\(button.wrappedValue.rawValue) clicked")
				viewModel.startAuthorization(button.wrappedValue)
			}) {
				Text(button.wrappedValue.rawValue)
					.frame(maxWidth: .infinity)
					.padding(5)
			}
			.disabled($viewModel.username.wrappedValue.isEmpty && button.wrappedValue != .authenticateUsernameless)
			.buttonStyle(.borderedProminent)
			.animation(.easeInOut, value: $viewModel.username.wrappedValue.isEmpty)
		}
	}

	var message: some View {
		guard let message = viewModel.message else {
			return AnyView(EmptyView())
		}

		let color: Color = message.type == .success ? .green : .red
		return AnyView(
			VStack {
				Text(message.title)
					.font(.subheadline)
					.bold()
					.frame(maxWidth: .infinity, alignment: .center)
				if let details = message.details {
					Text(details)
						.frame(maxWidth: .infinity, alignment: .center)
						.padding(.top, 10)
						.font(.caption)
				}
			}
			.foregroundColor(color)
			.padding(10)
			.overlay(
				RoundedRectangle(cornerRadius: 10)
					.stroke(color, lineWidth: 2)
			)
			.padding(.vertical, 30)
		)
	}

	var appConfiguration: some View {
		guard let configuration = viewModel.appConfiguration else {
			return AnyView(EmptyView())
		}

		return AnyView(
			VStack {
				Text("Host: \(configuration.host)")
					.font(.footnote)
			}
			.frame(maxWidth: .infinity, alignment: .center)
			.padding(10)
			.overlay(
				RoundedRectangle(cornerRadius: 10)
					.stroke(Color.black, lineWidth: 1)
			)
		)
	}
}

// MARK: - Preview

#Preview() {
	let viewModel = HomeScreenViewModel.preview
	viewModel.username = "User"
	viewModel.isAutoFillAssistedReady = true
	return HomeScreenView()
		.environmentObject(viewModel)
}

#Preview("Error message") {
	let viewModel = HomeScreenViewModel.preview
	viewModel.message = HomeScreenMessage(type: .error, title: "Error", details: "An error occurred")
	return HomeScreenView()
		.environmentObject(viewModel)
}

#Preview("Success message") {
	let viewModel = HomeScreenViewModel.preview
	viewModel.message = HomeScreenMessage(type: .success, title: "Success", details: "An error occurred")
	return HomeScreenView()
		.environmentObject(viewModel)
}

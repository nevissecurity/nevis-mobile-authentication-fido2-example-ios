//
// FIDO2 Example
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

	@StateObject private var viewModel: HomeScreenViewModel
	@FocusState private var focusedField: FocusedField?
	@State private var expandedSectionId: HomeScreenViewModel.Section.Id?

	// MARK: Initializer

	init(viewModel: HomeScreenViewModel = dependencyContainer ~> HomeScreenViewModel.self, expandedSectionId: HomeScreenViewModel.Section.Id? = nil) {
		_viewModel = StateObject(wrappedValue: viewModel)
		_expandedSectionId = State(initialValue: expandedSectionId)
	}

	// MARK: Body

	var body: some View {
		LoadingView(isShowing: $viewModel.isLoading) {
			GeometryReader { geometry in
				ScrollView {
					VStack {
						Text("FIDO 2 Example")
							.font(.title)
							.padding(.bottom, 30)
						sections
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

	// MARK: Sections

	var sections: some View {
		ForEach(viewModel.sections) { section in
			DisclosureGroup(
				isExpanded: Binding(
					get: { expandedSectionId == section.id },
					set: { isOpen in
						expandedSectionId = isOpen ? section.id : nil
					}
				),
				content: {
					VStack {
						Divider()
							.padding(.top, 10)
						switch section.id {
						case .register:
							usernameField()
							options(for: section)
						case .authenticate:
							usernameField(isAutoFillAssisted: true)
							options(for: section)
						case .authenticateUsernameless:
							EmptyView()
						}
						button(for: section)
						message
					}
				},
				label: {
					Text(section.title)
						.font(.headline)
						.foregroundColor(.primary)
				}
			)
			.accentColor(.accentColor)
			.padding(10)
			.background(
				RoundedRectangle(cornerRadius: 10)
					.stroke(Color(.separator), lineWidth: 1)
					.background(Color(.systemGray6).cornerRadius(10))
			)
			.onChange(of: expandedSectionId) { _ in
				viewModel.message = nil
			}
		}
	}

	// MARK: Components

	func usernameField(isAutoFillAssisted: Bool = false) -> some View {
		TextField("Username", text: $viewModel.username, prompt: Text("Enter username"))
			.textContentType(isAutoFillAssisted ? .username : nil)
			.textInputAutocapitalization(.never)
			.disableAutocorrection(true)
			.textFieldStyle(.roundedBorder)
			.focused($focusedField, equals: .username)
			.overlay {
				HStack {
					if isAutoFillAssisted {
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
			}
			.padding(.vertical, 10)
	}

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

	func button(for section: HomeScreenViewModel.Section) -> some View {
		Button(action: {
			print("\(section.title) clicked")
			viewModel.startAuthorization(section)
		}) {
			Text(section.title)
				.frame(maxWidth: .infinity)
				.padding(5)
		}
		.disabled($viewModel.username.wrappedValue.isEmpty && section.id != .authenticateUsernameless)
		.buttonStyle(.borderedProminent)
		.animation(.easeInOut, value: $viewModel.username.wrappedValue.isEmpty)
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
			.background(.white)
			.overlay(
				RoundedRectangle(cornerRadius: 10)
					.stroke(color, lineWidth: 2)
			)
			.clipShape(RoundedRectangle(cornerRadius: 10))
			.padding(.top, 10)
			.animation(.easeInOut, value: viewModel.message == nil)
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
	return HomeScreenView(viewModel: viewModel, expandedSectionId: .register)
}

#Preview("Authentication") {
	let viewModel = HomeScreenViewModel.preview
	viewModel.username = "User"
	viewModel.isAutoFillAssistedReady = true
	return HomeScreenView(viewModel: viewModel, expandedSectionId: .authenticate)
}

#Preview("Usernameless auth.") {
	let viewModel = HomeScreenViewModel.preview
	viewModel.username = "User"
	viewModel.isAutoFillAssistedReady = true
	return HomeScreenView(viewModel: viewModel, expandedSectionId: .authenticateUsernameless)
}

#Preview("Error message") {
	let viewModel = HomeScreenViewModel.preview
	viewModel.message = HomeScreenMessage(type: .error, title: "Error", details: "An error occurred")
	return HomeScreenView(viewModel: viewModel, expandedSectionId: .register)
}

#Preview("Success message") {
	let viewModel = HomeScreenViewModel.preview
	viewModel.message = HomeScreenMessage(type: .success, title: "Success", details: "An error occurred")
	return HomeScreenView(viewModel: viewModel, expandedSectionId: .authenticate)
}

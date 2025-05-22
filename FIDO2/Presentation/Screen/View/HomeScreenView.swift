//
// FIDO2 Example
//
// Copyright © 2025 Nevis Security AG. All rights reserved.
//

import SwiftUI
import SwinjectAutoregistration

struct HomeScreenView: View {
	// MARK: Properties

	@StateObject var viewModel: HomeScreenViewModel
	@FocusState var focusedField: FocusedField?
	@State var expandedSectionId: Int?
	@State var isFido2OptionGroupExpanded: Bool

	// MARK: Initializer

	init(
		viewModel: HomeScreenViewModel = dependencyContainer ~> HomeScreenViewModel.self,
		expandedSectionId: Int? = nil,
		isFido2OptionGroupExpanded: Bool = false
	) {
		_viewModel = StateObject(wrappedValue: viewModel)
		_expandedSectionId = State(wrappedValue: expandedSectionId)
		_isFido2OptionGroupExpanded = State(wrappedValue: isFido2OptionGroupExpanded)
	}

	// MARK: View

	var body: some View {
		LoadingView(isShowing: $viewModel.isLoading) {
			GeometryReader { geometry in
				ScrollView {
					VStack {
						Text("FIDO 2 Example")
							.appLabel()
						ForEach(viewModel.sections) { section in
							Fido2Section(
								id: section.id.rawValue,
								title: section.title,
								buttonLabel: section.buttonTitle,
								isButtonDisabled: viewModel.username.isEmpty && section.id != .authenticationUsernameless,
								expandedSectionId: $expandedSectionId,
								content: {
									VStack {
										if [HomeScreenViewModel.Section.ID.registration, HomeScreenViewModel.Section.ID.authentication].contains(section.id) {
											UsernameTextField(
												text: $viewModel.username,
												isAutoFillAssisted: section.id == .authentication,
												focusedField: $focusedField,
											)
											.padding(.bottom, 10)
											FIdo2OptionGroup(
												isRegistration: section.id == .registration,
												isExpanded: $isFido2OptionGroupExpanded,
												userVerificationRequirement: $viewModel.userVerificationRequirement,
												authenticatorAttachment: $viewModel.authenticatorAttachment,
												attestationConveyancePreference: $viewModel.attestationConveyancePreference,
												residentKeyRequirement: $viewModel.residentKeyRequirement,
											)
											.padding(.bottom, 10)
										}
									}
								},
								action: {
									viewModel.startAuthorization(section)
								},
								message: viewModel.message,
								focusedField: $focusedField,
							)
						}
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
		.onChange(of: expandedSectionId) { _ in
			viewModel.message = nil
		}
	}

	// MARK: Configuration

	var appConfiguration: some View {
		guard let configuration = viewModel.appConfiguration else {
			return AnyView(EmptyView())
		}

		return AnyView(
			VStack {
				Text("Host: \(configuration.host)")
					.font(.footnote)
			}
			.appConfigurationBox(),
		)
	}
}

// MARK: - Preview

#Preview() {
	var viewModel: HomeScreenViewModel = .preview
	viewModel.username = "User"
	viewModel.isAutoFillAssistedReady = true
	return HomeScreenView(
		viewModel: viewModel,
		expandedSectionId: 0,
		isFido2OptionGroupExpanded: true,
	)
}

#Preview("Authentication") {
	var viewModel: HomeScreenViewModel = .preview
	viewModel.username = "User"
	viewModel.isAutoFillAssistedReady = true
	return HomeScreenView(
		viewModel: viewModel,
		expandedSectionId: 1,
		isFido2OptionGroupExpanded: true,
	)
}

#Preview("Usernameless auth.") {
	HomeScreenView(
		viewModel: .preview,
		expandedSectionId: 2,
	)
}

#Preview("Error message") {
	var viewModel: HomeScreenViewModel = .preview
	viewModel.message = Message(type: .error, title: "Error", details: "An error occurred")
	return HomeScreenView(
		viewModel: viewModel,
		expandedSectionId: 0,
	)
}

#Preview("Success message") {
	var viewModel: HomeScreenViewModel = .preview
	viewModel.message = Message(type: .success, title: "Success", details: "Your authorization token is the following: TOKEN :)")
	return HomeScreenView(
		viewModel: viewModel,
		expandedSectionId: 0,
	)
}

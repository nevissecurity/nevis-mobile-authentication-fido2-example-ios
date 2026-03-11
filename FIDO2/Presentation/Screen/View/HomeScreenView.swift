//
// FIDO2 Example
//
// Copyright © 2026 Nevis Security AG. All rights reserved.
//

import SwiftUI
import SwinjectAutoregistration

/// The main (and only) screen of the app.
///
/// Displays:
/// - A title label
/// - A ``Fido2Section`` for each authorization type (registration, authentication,
///   usernameless authentication, web authorization)
/// - A ``Fido2OptionGroup`` inside the registration and authentication sections
///   for configuring FIDO2 policy options
/// - A ``LoadingView`` overlay while operations are in progress
/// - The configured host and web-authorization path at the bottom
struct HomeScreenView: View {
	// MARK: Properties

	/// The view model that drives the screen's state and authorization lifecycle.
	@StateObject var viewModel: HomeScreenViewModel
	/// Tracks which text field (if any) currently holds keyboard focus.
	@FocusState var focusedField: FocusedField?
	/// The identifier of the currently expanded section, or `nil` for all collapsed.
	@State var expandedSectionId: Int?
	/// Whether the FIDO2 options `DisclosureGroup` inside a section is expanded.
	@State var isFido2OptionGroupExpanded: Bool

	// MARK: Initializer

	/// Creates a `HomeScreenView` with an optional pre-built view model and initial state.
	///
	/// Intended for both normal use (resolved via `dependencyContainer`) and SwiftUI preview injection.
	///
	/// - Parameters:
	///   - viewModel: The view model to drive this view. Defaults to the container-resolved instance.
	///   - expandedSectionId: The section that should be expanded on first appearance, or `nil` for all collapsed.
	///   - isFido2OptionGroupExpanded: Whether the FIDO2 option group should be expanded on first appearance.
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
								buttons: section.buttons.map { button in
									(button.label, { viewModel.startAuthorization(button) })
								},
								isButtonDisabled: viewModel.username.isEmpty && [.registration, .authentication].contains(section.id),
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
											Fido2OptionGroup(
												isRegistration: section.id == .registration,
												isExpanded: $isFido2OptionGroupExpanded,
												userVerificationRequirement: $viewModel.userVerificationRequirement,
												authenticatorAttachment: $viewModel.authenticatorAttachment,
												attestationConveyancePreference: $viewModel.attestationConveyancePreference,
												residentKeyRequirement: $viewModel.residentKeyRequirement,
											)
											.padding(.bottom, 5)
										}
									}
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

	/// Renders the host and web-authorization path as a footnote box at the bottom of the screen.
	///
	/// Returns an `EmptyView` when the configuration has not yet been loaded.
	var appConfiguration: some View {
		guard let configuration = viewModel.appConfiguration else {
			return AnyView(EmptyView())
		}

		return AnyView(
			VStack {
				Text("Host: \(configuration.host)")
				Text("Path for Web Authorization: \(configuration.pathForAuthorization)")
			}
			.appConfigurationBox(),
		)
	}
}

// MARK: - Preview

#Preview() {
	let viewModel: HomeScreenViewModel = .preview
	viewModel.username = "User"
	viewModel.isAutoFillAssistedReady = true
	return HomeScreenView(
		viewModel: viewModel,
		expandedSectionId: 0,
		isFido2OptionGroupExpanded: true,
	)
}

#Preview("Authentication") {
	let viewModel: HomeScreenViewModel = .preview
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
	let viewModel: HomeScreenViewModel = .preview
	viewModel.message = Message(type: .error, title: "Error", details: "An error occurred")
	return HomeScreenView(
		viewModel: viewModel,
		expandedSectionId: 0,
	)
}

#Preview("Success message") {
	let viewModel: HomeScreenViewModel = .preview
	viewModel.message = Message(type: .success, title: "Success", details: "Your authorization token is the following: TOKEN :)")
	return HomeScreenView(
		viewModel: viewModel,
		expandedSectionId: 0,
	)
}

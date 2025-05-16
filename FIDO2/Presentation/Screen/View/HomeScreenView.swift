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

	@StateObject var viewModel: HomeScreenViewModel
	@FocusState var focusedField: FocusedField?
	@State var expandedSectionId: HomeScreenViewModel.Section.Id?

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

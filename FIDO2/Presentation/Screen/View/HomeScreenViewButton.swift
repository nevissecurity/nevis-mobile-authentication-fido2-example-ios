//
// FIDO2 Example
//
// Copyright © 2025 Nevis Security AG. All rights reserved.
//

import SwiftUI

extension HomeScreenView {
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
}

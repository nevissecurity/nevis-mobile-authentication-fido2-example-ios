//
// FIDO2 Example
//
// Copyright © 2025 Nevis Security AG. All rights reserved.
//

import SwiftUI

extension HomeScreenView {
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
}

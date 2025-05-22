//
// FIDO2 Example
//
// Copyright © 2025 Nevis Security AG. All rights reserved.
//

import SwiftUI

struct UsernameTextField: View {
	// MARK: Properties

	let placeholder: String = "Enter Username"

	@Binding var text: String
	var isAutoFillAssisted: Bool = false
	var focusedField: FocusState<FocusedField?>.Binding

	// MARK: View

	var body: some View {
		TextField("Username", text: $text, prompt: Text(placeholder))
			.textContentType(isAutoFillAssisted ? .username : nil)
			.textInputAutocapitalization(.never)
			.autocorrectionDisabled()
			.textFieldStyle(.roundedBorder)
			.focused(focusedField, equals: .username)
			.overlay {
				HStack {
					if isAutoFillAssisted {
						Spacer()
						Image(systemName: "person.badge.key")
							.resizable()
							.frame(width: 20, height: 20)
							.foregroundStyle(.accent)
							.opacity(isAutoFillAssisted ? 1 : 0)
							.padding(.trailing, 10)
							.animation(.easeInOut, value: isAutoFillAssisted)
					}
				}
			}
	}
}

// MARK: - Preview

@available(iOS 17.0, *)
#Preview() {
	@Previewable @State var text = "Sample Username"
	@Previewable @FocusState var focusedField: FocusedField?
	UsernameTextField(
		text: $text,
		isAutoFillAssisted: true,
		focusedField: $focusedField,
	)
}

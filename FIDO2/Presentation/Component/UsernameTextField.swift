//
// FIDO2 Example
//
// Copyright © 2026 Nevis Security AG. All rights reserved.
//

import SwiftUI

/// A text field for entering a username, with optional passkey auto-fill integration.
///
/// When `isAutoFillAssisted` is `true`:
/// - `.textContentType(.username)` is set, which triggers iOS to offer passkeys
///   via the QuickType bar (auto-fill assisted FIDO2 authentication).
/// - A key icon overlay is shown to signal the auto-fill state to the user.
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

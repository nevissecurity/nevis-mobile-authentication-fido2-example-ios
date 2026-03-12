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

	/// The placeholder text shown when the field is empty.
	let placeholder: String = "Enter Username"

	/// A binding to the entered username string.
	@Binding var text: String
	/// When `true`, enables passkey auto-fill via `.textContentType(.username)` and shows a key icon overlay.
	var isAutoFillAssisted: Bool = false
	/// Binding to the app-wide focus state, used to assign focus to this field.
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

//
// FIDO2 Example
//
// Copyright © 2026 Nevis Security AG. All rights reserved.
//

import SwiftUI

/// A collapsible `DisclosureGroup` section on the home screen.
///
/// Contains a divider, optional content (username field, option group), action buttons,
/// and a ``MessageView`` for displaying the operation result.
///
/// Only one section is expanded at a time, controlled by `expandedSectionId`.
struct Fido2Section<Content>: View, Identifiable where Content: View {
	// MARK: Properties

	let id: Int
	let title: String
	let buttons: [(String, () -> ())]
	var isButtonDisabled: Bool = false
	@Binding var expandedSectionId: Int?
	var content: () -> (Content)
	var message: Message?

	var focusedField: FocusState<FocusedField?>.Binding

	// MARK: View

	var body: some View {
		DisclosureGroup(
			isExpanded: Binding(
				get: { expandedSectionId == id },
				set: { isOpen in
					expandedSectionId = isOpen ? id : nil
				},
			),
			content: {
				VStack {
					Divider()
						.padding(.vertical, 10)
					content()
					ForEach(Array(buttons.enumerated()), id: \.0) { _, button in
						let (buttonLabel, action) = button
						Button(action: {
							print("Button \(buttonLabel) clicked")
							action()
						}) {
							Text(buttonLabel)
								.primaryButtonLabel()
						}
						.primaryButton(animationValue: isButtonDisabled)
						.disabled(isButtonDisabled)
					}
					MessageView(message: message)
						.padding(.vertical, 5)
				}
			},
			label: {
				Text(title)
					.sectionLabel()
			},
		)
		.fido2Section()
	}
}

// MARK: - Preview

@available(iOS 17.0, *)
#Preview() {
	@Previewable @State var expandedSectionId: Int? = 0
	@Previewable @FocusState var focusedField: FocusedField?
	Fido2Section(
		id: 0,
		title: "Section",
		buttons: [
			("Register", { print("Register clicked") }),
			("Authenticate", { print("Authenticate clicked") }),
		],
		isButtonDisabled: false,
		expandedSectionId: $expandedSectionId,
		content: {
			Text("Content")
		},
		message: .init(type: .error, title: "Title", details: "Message"),
		focusedField: $focusedField,
	)
}

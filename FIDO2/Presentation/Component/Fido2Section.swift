//
// FIDO2 Example
//
// Copyright © 2025 Nevis Security AG. All rights reserved.
//

import SwiftUI

struct Fido2Section<Content>: View, Identifiable where Content: View {
	// MARK: Properties

	let id: Int
	let title: String
	let buttonLabel: String

	var isButtonDisabled: Bool = false
	@Binding var expandedSectionId: Int?
	var content: () -> (Content)
	var action: () -> ()
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
					Button(action: {
						print("Button \(title) clicked")
						action()
					}) {
						Text(buttonLabel)
							.primaryButtonLabel()
					}
					.primaryButton(animationValue: isButtonDisabled)
					.disabled(isButtonDisabled)
					MessageView(message: message)
						.padding(.top, 10)
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
		buttonLabel: "Button",
		isButtonDisabled: false,
		expandedSectionId: $expandedSectionId,
		content: {
			Text("Content")
				.padding(.vertical, 20)
		},
		action: {},
		message: .init(type: .error, title: "Title", details: "Message"),
		focusedField: $focusedField,
	)
}

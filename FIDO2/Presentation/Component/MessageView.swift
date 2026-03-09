//
// FIDO2 Example
//
// Copyright © 2026 Nevis Security AG. All rights reserved.
//

import SwiftUI

/// Displays an operation result message with a colored border.
///
/// Success messages are rendered in green; error messages in red.
/// When `message` is `nil`, an `EmptyView` is rendered instead.
struct MessageView: View {
	// MARK: Properties

	let message: Message?

	// MARK: View

	var body: some View {
		guard let message else {
			return AnyView(EmptyView())
		}

		let color: Color = message.type == .success ? .green : .red
		return AnyView(
			VStack {
				Text(message.title)
					.messageLabel()
				if let details = message.details {
					Text(details)
						.messageDetailsLabel()
				}
			}
			.messageBox(color: color, animationValue: message.title),
		)
	}
}

// MARK: - Preview

#Preview() {
	MessageView(
		message: .init(type: .error, title: "Failure", details: "Sad message"),
	)
	MessageView(
		message: .init(type: .success, title: "Success", details: "Happy message"),
	)
}

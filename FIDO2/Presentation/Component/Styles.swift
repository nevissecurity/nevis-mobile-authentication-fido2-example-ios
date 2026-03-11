//
// FIDO2 Example
//
// Copyright © 2026 Nevis Security AG. All rights reserved.
//

import SwiftUI

// MARK: - Text

@MainActor
extension Text {
	/// Applies the app title style: `.title` font with bottom padding.
	/// - Returns: A `Text` view styled as the app title.
	func appLabel() -> some View {
		font(.title)
			.font(.title)
			.padding(.bottom, 30)
	}

	/// Applies the section header style: `.headline` font in primary colour.
	/// - Returns: A `Text` view styled as a section header.
	func sectionLabel() -> some View {
		font(.headline)
			.foregroundStyle(.primary)
	}

	/// Applies the option group label style: `.subheadline` font in secondary colour.
	/// - Returns: A `Text` view styled as an option group label.
	func optionGroupLabel() -> some View {
		font(.subheadline)
			.foregroundStyle(.secondary)
	}

	/// Applies the option picker label style: `.caption` font.
	/// - Returns: A `Text` view styled as an option picker label.
	func optionLabel() -> some View {
		font(.caption)
	}

	/// Applies the option title style: `.caption` font in secondary colour, full-width left-aligned.
	/// - Returns: A `Text` view styled as an option title.
	func optionTitle() -> some View {
		font(.caption)
			.foregroundStyle(.secondary)
			.frame(maxWidth: .infinity, alignment: .leading)
	}

	/// Applies the primary button label style: full-width with vertical padding.
	/// - Returns: A `Text` view styled as a primary button label.
	func primaryButtonLabel() -> some View {
		frame(maxWidth: .infinity)
			.padding(5)
	}

	/// Applies the message title style: bold `.subheadline`, centred.
	/// - Returns: A `Text` view styled as a message title.
	func messageLabel() -> some View {
		font(.subheadline)
			.bold()
			.frame(maxWidth: .infinity, alignment: .center)
	}

	/// Applies the message details style: `.caption`, centred with top padding.
	/// - Returns: A `Text` view styled as message details.
	func messageDetailsLabel() -> some View {
		font(.caption)
			.frame(maxWidth: .infinity, alignment: .center)
			.padding(.top, 10)
	}
}

// MARK: - Button

@MainActor
extension Button {
	/// Applies the primary button style: full-width, accent colour tint, bordered prominent, vertical padding, and easeInOut animation.
	/// - Parameter animationValue: Drives the easeInOut animation whenever this value changes.
	/// - Returns: A button styled as the primary action button.
	func primaryButton(animationValue: Bool) -> some View {
		frame(maxWidth: .infinity)
			.tint(.accentColor)
			.buttonStyle(.borderedProminent)
			.padding(.vertical, 5)
			.animation(.easeInOut, value: animationValue)
	}
}

// MARK: - DisclosureGroup

@MainActor
extension DisclosureGroup {
	/// Applies the section disclosure group style: rounded border on `systemGray6` background.
	/// - Returns: A disclosure group styled as a section container.
	func fido2Section() -> some View {
		tint(.primary)
			.padding(10)
			.background {
				RoundedRectangle(cornerRadius: 10)
					.stroke(Color(.separator), lineWidth: 1)
					.background { Color(.systemGray6).cornerRadius(10) }
			}
	}

	/// Applies the option group disclosure group style: rounded border on `systemGray5` background.
	/// - Returns: A disclosure group styled as an option group container.
	func fido2OptionGroup() -> some View {
		tint(.secondary)
			.padding(10)
			.background {
				RoundedRectangle(cornerRadius: 10)
					.stroke(Color(.separator), lineWidth: 1)
					.background { Color(.systemGray5).cornerRadius(10) }
			}
	}
}

// MARK: VStack

@MainActor
extension VStack {
	/// Applies the result message box style: coloured border and easeInOut animation.
	///
	/// - Parameters:
	///   - color: The border and foreground colour (green for success, red for error).
	///   - animationValue: Drives the easeInOut animation whenever this value changes.
	/// - Returns: A `VStack` styled as a message box with the specified border colour.
	func messageBox(color: Color, animationValue: String) -> some View {
		foregroundColor(color)
			.padding(10)
			.background(.white)
			.overlay(
				alignment: .center,
				content: {
					RoundedRectangle(cornerRadius: 10)
						.stroke(color, lineWidth: 2)
				}
			)
			.clipShape(RoundedRectangle(cornerRadius: 10))
			.animation(.easeInOut, value: animationValue)
	}

	/// Applies the app configuration info box style: footnote font, full-width, black border.
	/// - Returns: A `VStack` styled as an app configuration info box.
	func appConfigurationBox() -> some View {
		frame(maxWidth: .infinity, alignment: .center)
			.font(.footnote)
			.padding(10)
			.overlay(
				alignment: .center,
				content: {
					RoundedRectangle(cornerRadius: 10)
						.stroke(Color.black, lineWidth: 1)
				}
			)
	}
}

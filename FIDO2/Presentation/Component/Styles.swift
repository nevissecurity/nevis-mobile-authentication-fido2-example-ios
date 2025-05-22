//
// FIDO2 Example
//
// Copyright © 2025 Nevis Security AG. All rights reserved.
//

import SwiftUI

// MARK: - Text

@MainActor
extension Text {
	func appLabel() -> some View {
		font(.title)
			.font(.title)
			.padding(.bottom, 30)
	}

	func sectionLabel() -> some View {
		font(.headline)
			.foregroundStyle(.primary)
	}

	func optionGroupLabel() -> some View {
		font(.subheadline)
			.foregroundStyle(.secondary)
	}

	func optionLabel() -> some View {
		font(.caption)
	}

	func optionTitle() -> some View {
		font(.caption)
			.foregroundStyle(.secondary)
			.frame(maxWidth: .infinity, alignment: .leading)
	}

	func primaryButtonLabel() -> some View {
		frame(maxWidth: .infinity)
			.padding(5)
	}

	func messageLabel() -> some View {
		font(.subheadline)
			.bold()
			.frame(maxWidth: .infinity, alignment: .center)
	}

	func messageDetailsLabel() -> some View {
		font(.caption)
			.frame(maxWidth: .infinity, alignment: .center)
			.padding(.top, 10)
	}
}

// MARK: - Button

@MainActor
extension Button {
	func primaryButton(animationValue: Bool) -> some View {
		frame(maxWidth: .infinity)
			.tint(.accentColor)
			.buttonStyle(.borderedProminent)
			.padding(.bottom, 5)
			.animation(.easeInOut, value: animationValue)
	}
}

@MainActor
extension DisclosureGroup {
	func fido2Section() -> some View {
		tint(.primary)
			.padding(10)
			.background {
				RoundedRectangle(cornerRadius: 10)
					.stroke(Color(.separator), lineWidth: 1)
					.background { Color(.systemGray6).cornerRadius(10) }
			}
	}

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
	func messageBox(color: Color, animationValue: String) -> some View {
		foregroundColor(color)
			.padding(10)
			.background(.white)
			.overlay(alignment: .center, content: {
				RoundedRectangle(cornerRadius: 10)
					.stroke(color, lineWidth: 2)
			})
			.clipShape(RoundedRectangle(cornerRadius: 10))
			.animation(.easeInOut, value: animationValue)
	}

	func appConfigurationBox() -> some View {
		frame(maxWidth: .infinity, alignment: .center)
			.padding(10)
			.overlay(alignment: .center, content: {
				RoundedRectangle(cornerRadius: 10)
					.stroke(Color.black, lineWidth: 1)
			})
	}
}

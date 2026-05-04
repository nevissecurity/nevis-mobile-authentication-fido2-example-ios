//
// FIDO2 Example
//
// Copyright © 2026 Nevis Security AG. All rights reserved.
//

import SwiftUI

/// A transparent overlay that blurs and disables the underlying content while showing
/// a centered "Loading…" spinner.
///
/// Set `isShowing` to `true` to activate the overlay; set it to `false` to
/// restore the content. The transition is animated with `.easeInOut`.
struct LoadingView<Content>: View where Content: View {
	// MARK: Properties

	/// Whether the loading overlay is currently visible.
	@Binding var isShowing: Bool
	/// A view builder providing the content to display beneath the loading overlay.
	var content: () -> Content

	// MARK: Body

	var body: some View {
		GeometryReader { geometry in
			ZStack(alignment: .center) {
				content()
					.disabled(isShowing)
					.blur(radius: isShowing ? 3 : 0)

				VStack {
					Text("Loading...")
					ProgressView()
				}
				.frame(
					width: geometry.size.width / 2,
					height: geometry.size.height / 5,
				)
				.background { Color.secondary.colorInvert() }
				.foregroundStyle(.primary)
				.clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
				.opacity(isShowing ? 1 : 0)
			}
		}
		.animation(.easeInOut, value: isShowing)
	}
}

// MARK: - Preview

#Preview {
	LoadingView(isShowing: .constant(true)) {
		VStack {
			Text("Preview Content")
				.offset(.init(width: 0, height: -50))
		}
		.frame(maxWidth: .infinity, maxHeight: .infinity)
	}
}

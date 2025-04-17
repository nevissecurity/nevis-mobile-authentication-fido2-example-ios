//
// FIDO2 Example App
//
// Copyright © 2025 Nevis Security AG. All rights reserved.
//

import SwiftUI

/// A view that displays a loading indicator over the content
struct LoadingView<Content>: View where Content: View {
	// MARK: Properties

	@Binding var isShowing: Bool
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
				.frame(width: geometry.size.width / 2,
				       height: geometry.size.height / 5)
				.background(Color.secondary.colorInvert())
				.foregroundColor(.primary)
				.cornerRadius(20)
				.opacity(isShowing ? 1 : 0)
			}
		}
		.animation(.easeInOut, value: isShowing)
	}
}

// MARK: - Preview

#Preview {
	// TODO: check for iOS 16 compatible preview
//	@Previewable @State var isLoading = true
//	LoadingView(isShowing: $isLoading) {
//		VStack {}
//			.frame(maxWidth: .infinity, maxHeight: .infinity)
//	}
}

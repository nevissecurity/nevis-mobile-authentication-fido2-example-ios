//
// FIDO2 Example
//
// Copyright © 2025 Nevis Security AG. All rights reserved.
//

import SwiftUI

extension HomeScreenView {
	var message: some View {
		guard let message = viewModel.message else {
			return AnyView(EmptyView())
		}

		let color: Color = message.type == .success ? .green : .red
		return AnyView(
			VStack {
				Text(message.title)
					.font(.subheadline)
					.bold()
					.frame(maxWidth: .infinity, alignment: .center)
				if let details = message.details {
					Text(details)
						.frame(maxWidth: .infinity, alignment: .center)
						.padding(.top, 10)
						.font(.caption)
				}
			}
			.foregroundColor(color)
			.padding(10)
			.background(.white)
			.overlay(
				RoundedRectangle(cornerRadius: 10)
					.stroke(color, lineWidth: 2)
			)
			.clipShape(RoundedRectangle(cornerRadius: 10))
			.padding(.top, 10)
			.animation(.easeInOut, value: viewModel.message == nil)
		)
	}
}

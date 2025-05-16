//
// FIDO2 Example
//
// Copyright © 2025 Nevis Security AG. All rights reserved.
//

import SwiftUI

extension HomeScreenView {
	var appConfiguration: some View {
		guard let configuration = viewModel.appConfiguration else {
			return AnyView(EmptyView())
		}

		return AnyView(
			VStack {
				Text("Host: \(configuration.host)")
					.font(.footnote)
			}
			.frame(maxWidth: .infinity, alignment: .center)
			.padding(10)
			.overlay(
				RoundedRectangle(cornerRadius: 10)
					.stroke(Color.black, lineWidth: 1)
			)
		)
	}
}

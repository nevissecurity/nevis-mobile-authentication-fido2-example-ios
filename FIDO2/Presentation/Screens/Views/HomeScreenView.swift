//
// FIDO2 PoC
//
// Copyright © 2025 NEVIS. All rights reserved.
//

import SwiftUI
import Combine

struct HomeScreenView: View {
	@StateObject private var viewModel = HomeScreenViewModel()

	var body: some View {
		LoadingView(isShowing: $viewModel.isLoading) {
			VStack {
				Text("FIDO 2 example app")
					.font(.title)
					.padding(.bottom, 20)
				
				Text("Username")
					.frame(maxWidth: .infinity, alignment: .leading)
					.padding(.leading)
				TextField("Enter username", text: $viewModel.username)
					.textContentType(.username)
					.textFieldStyle(RoundedBorderTextFieldStyle())
					.padding()
				Button(action: {
					print("Register clicked")
					viewModel.register()
				}) {
					Text("Register")
				}
				.disabled($viewModel.username.wrappedValue.isEmpty)
				.padding()
				.frame(maxWidth: .infinity)
				.overlay(
					RoundedRectangle(cornerRadius: 10)
						.stroke(Color.blue, lineWidth: 1)
				)
				
				Button(action: {
					print("Authenticate clicked")
				}) {
					Text("Authenticate")
				}
				.disabled($viewModel.username.wrappedValue.isEmpty)
				.padding()
				.frame(maxWidth: .infinity)
				.overlay(
					RoundedRectangle(cornerRadius: 10)
						.stroke(Color.blue, lineWidth: 1)
				)
				Spacer()

				if let errorMessage = viewModel.errorMessage {
					VStack {
						Text(viewModel.errorTitle ?? "Error")
							.font(.system(size: 20, weight: .bold))
							.frame(maxWidth: .infinity, alignment: .center)
							.padding(.horizontal)
						Text("\(errorMessage)")
					}
					.foregroundColor(.red)
					.padding(10)
					.overlay(
						RoundedRectangle(cornerRadius: 10)
							.stroke(Color.red, lineWidth: 2)
					)
				}

				Spacer()

				if let config = viewModel.appConfiguration {
					VStack {
						Text("Configuration")
							.frame(maxWidth: .infinity, alignment: .leading)
							.padding(.leading)
						Text("Base URL: \(config.baseUrl)")
						Text("Start enroll path: \(config.startEnrollPath)")
					}
					.padding(10)
					.overlay(
						RoundedRectangle(cornerRadius: 10)
							.stroke(Color.black, lineWidth: 1)
					)
				}

				Spacer()
			}
			.padding()
			.task {
				viewModel.loadConfiguration()
			}
		}
	}
}

#Preview {
	HomeScreenView()
}

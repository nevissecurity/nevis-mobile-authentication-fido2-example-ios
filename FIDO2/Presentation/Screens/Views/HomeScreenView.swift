//
// FIDO2 Example App
//
// Copyright © 2025 Nevis Security AG. All rights reserved.
//

import SwiftUI
import SwinjectAutoregistration

struct HomeScreenView: View {
	enum FocusedField {
		case username
	}

	@StateObject private var viewModel = dependencyContainer ~> HomeScreenViewModel.self
	@FocusState private var focusedField: FocusedField?

	var body: some View {
		LoadingView(isShowing: $viewModel.isLoading) {
			VStack {
				Text("FIDO 2 Example")
					.font(.title)
					.padding(.bottom, 30)

				Text("Username")
					.frame(maxWidth: .infinity, alignment: .leading)
					.font(.subheadline)
				TextField("Username", text: $viewModel.username, prompt: Text("Enter username"))
					.textContentType(.username)
					.textInputAutocapitalization(.never)
					.disableAutocorrection(true)
					.textFieldStyle(.roundedBorder)
					.focused($focusedField, equals: .username)
					.overlay {
						HStack {
							Spacer()
							Image(systemName: "person.badge.key")
								.resizable()
								.frame(width: 20, height: 20)
								.foregroundColor(.accentColor)
								.opacity(viewModel.isAutoFillAssistedReady ? 1 : 0)
								.padding(.trailing, 10)
								.animation(.easeInOut, value: viewModel.isAutoFillAssistedReady)
						}
					}
					.padding(.bottom, 20)

				buttons
				message
					.animation(.easeInOut, value: viewModel.message == nil)
				Spacer()
				appConfiguration
			}
			.padding()
		}
		.onAppear {
			focusedField = .username
		}
		.onTapGesture {
			focusedField = nil
		}
	}

	var buttons: some View {
		ForEach($viewModel.buttons, id: \.self) { button in
			Button(action: {
				print("\(button.wrappedValue.rawValue) clicked")
				viewModel.startAuthorization(button.wrappedValue)
			}) {
				Text(button.wrappedValue.rawValue)
					.frame(maxWidth: .infinity)
					.padding(5)
			}
			.disabled($viewModel.username.wrappedValue.isEmpty && button.wrappedValue != .authenticateUsernameless)
			.buttonStyle(.borderedProminent)
			.animation(.easeInOut, value: $viewModel.username.wrappedValue.isEmpty)
		}
	}

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
			.overlay(
				RoundedRectangle(cornerRadius: 10)
					.stroke(color, lineWidth: 2)
			)
			.padding(.top, 30)
		)
	}

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

#Preview {
	HomeScreenView()
}

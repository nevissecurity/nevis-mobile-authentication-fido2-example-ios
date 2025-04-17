//
// FIDO2 Example App
//
// Copyright © 2025 Nevis Security AG. All rights reserved.
//

import AuthenticationServices
import Combine
import SwiftUI

final class HomeScreenViewModel: ObservableObject {
	@Published var isLoading = false
	@Published var isAutoFillAssistedReady = false
	@Published private(set) var message: HomeScreenMessage?
	@Published private(set) var appConfiguration: AppConfiguration?
	@Published var username: String = ""
	@Published var buttons: [HomeScreenViewModel.ButtonType] = [
		.register,
		.authenticate,
		.authenticateUsernameless,
	]

	private var cancellables: Set<AnyCancellable> = []
	private let authorizationService: AuthorizationService
	private let startAuthorizationUseCase: StartAuthorizationUseCase
	private let completeAuthorizationUseCase: CompleteAuthorizationUseCase

	init(configurationLoader: ConfigurationLoader, authorizationService: AuthorizationService, startAuthorizationUseCase: StartAuthorizationUseCase, completeAuthorizationUseCase: CompleteAuthorizationUseCase) {
		self.authorizationService = authorizationService
		self.startAuthorizationUseCase = startAuthorizationUseCase
		self.completeAuthorizationUseCase = completeAuthorizationUseCase

		loadConfiguration(configurationLoader)
		subscribeToAuthorizationService()
		startAutoFillAssistedAuthorization()
	}

	private func loadConfiguration(_ configurationLoader: ConfigurationLoader) {
		do {
			appConfiguration = try configurationLoader.config
		}
		catch {
			setMessage(.error, title: "Configuration error", details: error.localizedDescription)
		}
	}

	func startAuthorization(_ buttonType: ButtonType) {
		guard let authorizationRequest = authorizationRequest(by: buttonType) else { return }
		clearMessage()
		isLoading = true
		startAuthorizationUseCase.execute(authorizationRequest)
			.receive(on: DispatchQueue.main)
			.sink(
				receiveCompletion: { [weak self] completion in
					if case let .failure(error) = completion {
						self?.setMessage(.error, title: "Starting authorization failed", details: error.localizedDescription)
						self?.startAutoFillAssistedAuthorization()
					}
				},
				receiveValue: { [weak self] startAuthorizationResponse in
					self?.authorizationService.start(startAuthorizationResponse, isAutoFillAssisted: false)
				}
			)
			.store(in: &cancellables)
	}

	private func startAutoFillAssistedAuthorization() {
		isLoading = false
		isAutoFillAssistedReady = false
		startAuthorizationUseCase.execute(.credentialAssertion())
			.sink(
				receiveCompletion: { _ in },
				receiveValue: { [weak self] startAuthorizationResponse in
					guard let self else { return }
					authorizationService.start(startAuthorizationResponse, isAutoFillAssisted: true)
					isAutoFillAssistedReady = true
				}
			)
			.store(in: &cancellables)
	}

	private func completeAuthorization(_ request: CompleteAuthorizationRequest) {
		isLoading = true
		completeAuthorizationUseCase.execute(request)
			.receive(on: DispatchQueue.main)
			.sink(
				receiveCompletion: { [weak self] completion in
					if case let .failure(error) = completion {
						self?.setMessage(.error, title: "Completing authorization failed", details: error.localizedDescription)
					}
					self?.startAutoFillAssistedAuthorization()
				},
				receiveValue: { [weak self] in
					self?.setMessage(.success, title: "Authorization successfully completed")
				}
			)
			.store(in: &cancellables)
	}
}

// MARK: - Message

extension HomeScreenViewModel {
	func setMessage(_ messageType: HomeScreenMessage.MessageType = .success, title: String, details: String? = nil) {
		print("\(title)\(details != nil ? ": \(details!)" : "")")

		message = HomeScreenMessage(
			type: messageType,
			title: title,
			details: details,
		)

		isLoading = false
	}

	func clearMessage() {
		message = nil
	}
}

// MARK: - Authorization requests

private extension HomeScreenViewModel {
	func authorizationRequest(by buttonType: ButtonType) -> StartAuthorizationRequest? {
		switch (buttonType, username.isEmpty) {
		case (.register, false):
			.credentialRegistration(username: username)
		case (.authenticate, false):
			.credentialAssertion(username: username)
		case (.authenticateUsernameless, _):
			.credentialAssertion()
		default:
			nil
		}
	}
}

// MARK: - Subscribing to Authorizations Service

private extension HomeScreenViewModel {
	func subscribeToAuthorizationService() {
		authorizationService.onComplete
			.sink { [weak self] result in
				switch result {
				case let .success(authorization):
					self?.completeAuthorization(authorization)
				case let .failure(error):
					if case let .canceled(isAutoFillAssisted) = error, isAutoFillAssisted {
						return
					}
					self?.setMessage(.error, title: "Authorization error", details: error.localizedDescription)
					self?.startAutoFillAssistedAuthorization()
				}
			}
			.store(in: &cancellables)
	}
}

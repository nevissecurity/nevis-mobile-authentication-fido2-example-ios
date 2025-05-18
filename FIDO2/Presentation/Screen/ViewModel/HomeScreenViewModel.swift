//
// FIDO2 Example
//
// Copyright © 2025 Nevis Security AG. All rights reserved.
//

import AuthenticationServices
import Combine
import SwiftUI

final class HomeScreenViewModel: ObservableObject {
	// MARK: Properties

	@Published var isLoading = false
	@Published var isAutoFillAssistedReady = false

	@Published var message: Message?
	@Published private(set) var appConfiguration: AppConfiguration?

	@Published var username: String = ""
	@Published var sections: [Section] = [
		.init(id: .registration, title: "Registration", buttonTitle: "Register"),
		.init(id: .authentication, title: "Authentication", buttonTitle: "Authenticate"),
		.init(id: .authenticationUsernameless, title: "Authentication (Usernameless)", buttonTitle: "Authenticate"),
	]

	@Published var userVerificationRequirement: Fido2RequirementViewOption = .unspecified
	@Published var authenticatorAttachment: Fido2AuthenticatorAttachmentViewOption = .unspecified
	@Published var requirementConveyancePreference: Fido2RequirementConveyancePreferenceViewOption = .unspecified
	@Published var residentKeyRequirement: Fido2RequirementViewOption = .unspecified

	private var cancellables: Set<AnyCancellable> = []
	private let authorizationService: AuthorizationService
	private let startAuthorizationUseCase: StartAuthorizationUseCase
	private let completeAuthorizationUseCase: CompleteAuthorizationUseCase

	// MARK: Initializer

	init(configurationLoader: ConfigurationLoader, authorizationService: AuthorizationService, startAuthorizationUseCase: StartAuthorizationUseCase, completeAuthorizationUseCase: CompleteAuthorizationUseCase) {
		self.authorizationService = authorizationService
		self.startAuthorizationUseCase = startAuthorizationUseCase
		self.completeAuthorizationUseCase = completeAuthorizationUseCase

		loadConfiguration(configurationLoader)
		optionValidations()
		subscribeToAuthorizationService()
		startAutoFillAssistedAuthorization()
	}

	// MARK: Authorization

	func startAuthorization(_ section: Section) {
		guard let authorizationRequest = authorizationRequest(for: section) else { return }
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
}

// MARK: - Message

extension HomeScreenViewModel {
	func setMessage(_ messageType: Message.MessageType = .success, title: String, details: String? = nil) {
		print("\(title)\(details != nil ? ": \(details!)" : "")")

		message = Message(
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
	func startAutoFillAssistedAuthorization() {
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

	func completeAuthorization(_ request: CompleteAuthorizationRequest) {
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
				receiveValue: { [weak self] authorizationToken in
					self?.setMessage(.success, title: "Authorization successfully completed", details: "Authorization token: \(authorizationToken)")
				}
			)
			.store(in: &cancellables)
	}
}

// MARK: - Configuration

private extension HomeScreenViewModel {
	func loadConfiguration(_ configurationLoader: ConfigurationLoader) {
		do {
			appConfiguration = try configurationLoader.config
		}
		catch {
			setMessage(.error, title: "Configuration error", details: error.localizedDescription)
		}
	}

	func optionValidations() {
		// Validate the relationship of FIDO 2 options
		$authenticatorAttachment
			.sink { [weak self] authenticatorAttachement in
				if authenticatorAttachement != .crossPlatform {
					self?.requirementConveyancePreference = .unspecified
					self?.residentKeyRequirement = .unspecified
				}
			}
			.store(in: &cancellables)
	}
}

// MARK: - Authorization requests

private extension HomeScreenViewModel {
	func authorizationRequest(for section: Section) -> StartAuthorizationRequest? {
		switch (section.id, username.isEmpty) {
		case (.registration, false):
			.credentialRegistration(
				username: username,
				fido2Options: .map(from: (userVerificationRequirement, authenticatorAttachment, requirementConveyancePreference, residentKeyRequirement))
			)
		case (.authentication, false):
			.credentialAssertion(
				username: username,
				fido2Options: .map(from: userVerificationRequirement)
			)
		case (.authenticationUsernameless, _):
			.credentialAssertion(
				username: nil,
				fido2Options: .map(from: userVerificationRequirement)
			)
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

// MARK: - Preview

extension HomeScreenViewModel {
	static var preview: some HomeScreenViewModel {
		HomeScreenViewModel(
			configurationLoader: ConfigurationLoaderImpl.preview,
			authorizationService: AuthorizationServiceImpl.preview,
			startAuthorizationUseCase: StartAuthorizationUseCaseImpl.preview,
			completeAuthorizationUseCase: CompleteAuthorizationUseCaseImpl.preview
		)
	}
}

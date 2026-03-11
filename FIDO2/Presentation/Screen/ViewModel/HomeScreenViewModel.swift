//
// FIDO2 Example
//
// Copyright © 2026 Nevis Security AG. All rights reserved.
//

import AuthenticationServices
import Combine
import SwiftUI

/// The single view model driving ``HomeScreenView``.
///
/// Coordinates the full FIDO2 authorization lifecycle:
/// 1. The view triggers ``startAuthorization(_:)`` with a ``SectionButton``.
/// 2. ``startAuthorization(_:)`` calls ``StartAuthorizationUseCase`` to get server options.
/// 3. ``AuthorizationService`` presents the system passkey or web UI.
/// 4. On completion, `completeAuthorization(_:)` calls ``CompleteAuthorizationUseCase``.
/// 5. The resulting JWT is introspected and the result displayed via ``message``.
///
/// Web authorization callbacks are handled via SwiftUI's `.onOpenURL` modifier, which
/// calls ``AuthorizationService/startWeb(url:callbackUrlScheme:)`` internally.
final class HomeScreenViewModel: ObservableObject {
	// MARK: Properties

	/// Whether a network or authorization operation is in progress.
	@Published var isLoading = false
	/// Whether the auto-fill assisted passkey assertion request has been registered with the OS.
	@Published var isAutoFillAssistedReady = false

	/// The last operation result message, shown in the active section. `nil` when cleared.
	@Published var message: Message?
	/// The loaded app configuration (host, token, path), or `nil` if not yet loaded.
	@Published private(set) var appConfiguration: AppConfiguration?

	/// The username entered by the user for registration or authentication.
	@Published var username: String = ""
	/// The list of sections shown in the home screen.
	@Published var sections: [Section] = [
		.init(id: .registration, title: "Registration", buttons: [.init(.registration, "Register")]),
		.init(id: .authentication, title: "Authentication", buttons: [.init(.authentication, "Authenticate")]),
		.init(id: .authenticationUsernameless, title: "Authentication (Usernameless)", buttons: [.init(.authenticationUsernameless, "Authenticate")]),
		.init(id: .authorizationViaWebview, title: "Authorization via Web", buttons: [.init(.registrationViaWebview, "Register via Web"), .init(.authenticationViaWebview, "Authenticate via Web")]),
	]

	/// The user verification requirement selected in the FIDO2 options UI.
	@Published var userVerificationRequirement: Fido2RequirementViewOption = .unspecified
	/// The authenticator attachment constraint selected in the FIDO2 options UI.
	@Published var authenticatorAttachment: Fido2AuthenticatorAttachmentViewOption = .unspecified
	/// The attestation conveyance preference selected in the FIDO2 options UI.
	@Published var attestationConveyancePreference: Fido2AttestationConveyancePreferenceViewOption = .unspecified
	/// The resident key requirement selected in the FIDO2 options UI.
	@Published var residentKeyRequirement: Fido2RequirementViewOption = .unspecified

	private var cancellables: Set<AnyCancellable> = []
	private let authorizationService: AuthorizationService
	private let startAuthorizationUseCase: StartAuthorizationUseCase
	private let completeAuthorizationUseCase: CompleteAuthorizationUseCase
	private let introspectUseCase: IntrospectUseCase

	// MARK: Initializer

	/// Creates the view model and wires up all subscriptions.
	///
	/// Loads the app configuration, sets up FIDO2 option validation rules, subscribes to
	/// ``AuthorizationService/onComplete``, and registers an auto-fill assisted assertion request.
	///
	/// - Parameters:
	///   - configurationLoader: Provides the app's host, access token, and web authorization path.
	///   - authorizationService: Manages the `ASAuthorizationController` and `ASWebAuthenticationSession` lifecycle.
	///   - startAuthorizationUseCase: Initiates registration and authentication ceremonies.
	///   - completeAuthorizationUseCase: Completes registration and authentication ceremonies.
	///   - introspectUseCase: Validates the JWT returned after a successful ceremony.
	init(configurationLoader: ConfigurationLoader, authorizationService: AuthorizationService, startAuthorizationUseCase: StartAuthorizationUseCase, completeAuthorizationUseCase: CompleteAuthorizationUseCase, introspectUseCase: IntrospectUseCase) {
		self.authorizationService = authorizationService
		self.startAuthorizationUseCase = startAuthorizationUseCase
		self.completeAuthorizationUseCase = completeAuthorizationUseCase
		self.introspectUseCase = introspectUseCase

		loadConfiguration(configurationLoader)
		optionValidations()
		subscribeToAuthorizationService()
		startAutoFillAssistedAuthorization()
	}

	// MARK: Authorization

	/// Clears the current message, sets `isLoading`, and starts the authorization flow
	/// corresponding to the tapped section button.
	func startAuthorization(_ sectionButton: SectionButton) {
		guard let authorizationRequest = authorizationRequest(for: sectionButton) else { return }
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
					switch startAuthorizationResponse {
						case .credentialRegistration,
							.credentialAssertion:
							self?.authorizationService.start(startAuthorizationResponse, isAutoFillAssisted: false)
						default:
							self?.isLoading = false
					}
				},
			)
			.store(in: &cancellables)
	}
}

// MARK: - Message

extension HomeScreenViewModel {
	/// Sets ``message`` with the given type, title, and optional details, then clears ``isLoading``.
	///
	/// Also prints the message to the console for debugging purposes.
	///
	/// - Parameters:
	///   - messageType: The visual style (`.success` or `.error`). Defaults to `.success`.
	///   - title: The primary message text.
	///   - details: Optional secondary detail text.
	func setMessage(_ messageType: Message.MessageType = .success, title: String, details: String? = nil) {
		print("\(title)\(details != nil ? ": \(details!)" : "")")

		message = Message(
			type: messageType,
			title: title,
			details: details,
		)

		isLoading = false
	}

	/// Clears the currently displayed message.
	func clearMessage() {
		message = nil
	}
}

// MARK: - Authorization requests

private extension HomeScreenViewModel {
	/// Registers an auto-fill assisted assertion request with the OS (QuickType bar passkey suggestion).
	///
	/// Resets ``isLoading`` and ``isAutoFillAssistedReady`` before starting, and sets
	/// ``isAutoFillAssistedReady`` to `true` once the system has accepted the request.
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
				},
			)
			.store(in: &cancellables)
	}

	/// Calls ``CompleteAuthorizationUseCase`` with the given request and then introspects the resulting token.
	///
	/// - Parameter request: The completion data (device name / status token / raw credential bytes).
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
					self?.introspectAuthorizationToken(authorizationToken)
				},
			)
			.store(in: &cancellables)
	}

	/// Introspects the JWT and updates ``message`` with validity and claim information.
	///
	/// - Parameter token: The JWT string returned after a successful ceremony or web authorization.
	func introspectAuthorizationToken(_ token: AuthorizationToken) {
		introspectUseCase.execute(token: token)
			.receive(on: DispatchQueue.main)
			.sink(
				receiveCompletion: { [weak self] completion in
					if case let .failure(error) = completion {
						self?.setMessage(.error, title: "Introspect failed", details: error.localizedDescription)
					}
				},
				receiveValue: { [weak self] info in
					let title = "Token is \(info.isActive ? "valid" : "invalid")"
					var details: [String] = []
					if let issuedAt = info.issuedAt {
						details.append("Issued at: \(Date(epochInMillis: issuedAt).formatted)")
					}
					if let subject = info.subject {
						details.append("User ID: \(subject)")
					}
					self?.setMessage(info.isActive ? .success : .error, title: title, details: details.joined(separator: "\n"))
				},
			)
			.store(in: &cancellables)
	}
}

// MARK: - Configuration

private extension HomeScreenViewModel {
	/// Loads the app configuration synchronously and stores it in ``appConfiguration``.
	///
	/// On failure, sets ``message`` to an error state.
	///
	/// - Parameter configurationLoader: The loader to read the configuration from.
	func loadConfiguration(_ configurationLoader: ConfigurationLoader) {
		do {
			appConfiguration = try configurationLoader.config
		} catch {
			setMessage(.error, title: "Configuration error", details: error.localizedDescription)
		}
	}

	/// Sets up reactive option validation rules.
	///
	/// When `authenticatorAttachment` changes away from `.crossPlatform`, resets the other
	/// three FIDO2 option pickers to their recommended platform-authenticator defaults.
	func optionValidations() {
		// Validate the relationship of FIDO 2 options
		$authenticatorAttachment
			.sink { [weak self] authenticatorAttachement in
				if authenticatorAttachement != .crossPlatform {
					self?.userVerificationRequirement = .preferred
					self?.attestationConveyancePreference = .none
					self?.residentKeyRequirement = .required
				} else {
					self?.userVerificationRequirement = .unspecified
					self?.attestationConveyancePreference = .unspecified
					self?.residentKeyRequirement = .unspecified
				}
			}
			.store(in: &cancellables)
	}
}

// MARK: - Authorization requests

private extension HomeScreenViewModel {
	/// Builds the ``StartAuthorizationRequest`` for the tapped section button.
	///
	/// Returns `nil` when a username is required but the field is empty.
	///
	/// - Parameter sectionButton: The button that was tapped.
	/// - Returns: The matching ``StartAuthorizationRequest``, or `nil` if prerequisites are not met.
	func authorizationRequest(for sectionButton: SectionButton) -> StartAuthorizationRequest? {
		switch (sectionButton.id, username.isEmpty) {
			case (.registration, false):
				.credentialRegistration(
					username: username,
					fido2Options: .map(from: (userVerificationRequirement, authenticatorAttachment, attestationConveyancePreference, residentKeyRequirement)),
				)
			case (.authentication, false):
				.credentialAssertion(
					username: username,
					fido2Options: .map(from: userVerificationRequirement),
				)
			case (.authenticationUsernameless, _):
				.credentialAssertion(
					username: nil,
					fido2Options: .map(from: userVerificationRequirement),
				)
			case (.registrationViaWebview, _):
				.credentialRegistrationViaWeb
			case (.authenticationViaWebview, _):
				.credentialAssertionViaWeb
			default:
				nil
		}
	}
}

// MARK: - Subscribing to Authorizations Service

private extension HomeScreenViewModel {
	/// Subscribes to ``AuthorizationService/onComplete`` and routes each result to the appropriate handler.
	///
	/// Successful passkey results → ``completeAuthorization(_:)``
	/// Web authorization results → ``introspectAuthorizationToken(_:)``
	/// Failures (non-silent) → error message + restart auto-fill
	func subscribeToAuthorizationService() {
		authorizationService.onComplete
			.sink { [weak self] result in
				switch result {
					case let .success(authorization):
						switch authorization {
							case let .completedWebAuthorization(authorizationToken):
								self?.introspectAuthorizationToken(authorizationToken)
							default:
								self?.completeAuthorization(authorization)
						}
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
	/// A pre-configured instance used for SwiftUI previews.
	static var preview: some HomeScreenViewModel {
		HomeScreenViewModel(
			configurationLoader: ConfigurationLoaderImpl.preview,
			authorizationService: AuthorizationServiceImpl.preview,
			startAuthorizationUseCase: StartAuthorizationUseCaseImpl.preview,
			completeAuthorizationUseCase: CompleteAuthorizationUseCaseImpl.preview,
			introspectUseCase: IntrospectUseCaseImpl.preview,
		)
	}
}

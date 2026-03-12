//
// FIDO2 Example
//
// Copyright © 2026 Nevis Security AG. All rights reserved.
//

import Combine
import Foundation

/// Concrete implementation of ``StartAuthorizationUseCase``.
///
/// Coordinates between ``Fido2Repository`` (for server-side challenge acquisition)
/// and ``AuthorizationService`` (for triggering the system FIDO2 UI).
final class StartAuthorizationUseCaseImpl {
	/// Provides the app configuration used to build web authorization URLs.
	private let configurationLoader: ConfigurationLoader
	/// Used to initiate server-side registration and authentication ceremonies.
	private let fido2Repository: Fido2Repository
	/// Used to start web-based OAuth/OIDC authorization sessions.
	private let authenticationService: AuthorizationService

	/// Creates an instance with all required collaborators.
	///
	/// - Parameters:
	///   - configurationLoader: Provides the app configuration (host, access token, web-auth path).
	///   - fido2Repository: Used for server-side registration and authentication ceremony initiation.
	///   - authenticationService: Used to start web-based authorization sessions.
	init(configurationLoader: ConfigurationLoader, fido2Repository: Fido2Repository, authenticationService: AuthorizationService) {
		self.configurationLoader = configurationLoader
		self.fido2Repository = fido2Repository
		self.authenticationService = authenticationService
	}
}

// MARK: - StartAuthorizationUseCase

extension StartAuthorizationUseCaseImpl: StartAuthorizationUseCase {
	/// Routes the request to the correct repository call based on the ``StartAuthorizationRequest`` type:
	/// - `.credentialRegistration` → ``Fido2Repository/startRegistration(username:fido2Options:)``
	/// - `.credentialAssertion` → ``Fido2Repository/startApproval(username:fido2Options:)``
	/// - `.credentialRegistrationViaWeb` / `.credentialAssertionViaWeb` → ``AuthorizationService/startWeb(url:callbackUrlScheme:)``
	func execute(_ type: StartAuthorizationRequest) -> AnyPublisher<StartAuthorizationResponse, AppError> {
		switch type {
			case let .credentialRegistration(username, fido2Options):
				fido2Repository.startRegistration(username: username, fido2Options: fido2Options)
			case let .credentialAssertion(username, fido2Options):
				fido2Repository.startApproval(username: username, fido2Options: fido2Options)
			case .credentialRegistrationViaWeb,
				.credentialAssertionViaWeb:
				{
					guard let callbackUrlScheme = Bundle.main.urlSchemes.first else {
						return Fail(error: AppError.configuration(message: "Callback URL scheme not configured"))
							.eraseToAnyPublisher()
					}

					let webAuthorizationUrl = urlForWebAuthorization(for: type, redirectScheme: callbackUrlScheme)
					authenticationService.startWeb(url: webAuthorizationUrl, callbackUrlScheme: callbackUrlScheme)
					return Just(.webAuthorization)
						.setFailureType(to: AppError.self)
						.eraseToAnyPublisher()
				}()
		}
	}
}

// MARK: - Determining Web Authorization URL

private extension StartAuthorizationUseCaseImpl {
	/// Constructs the full web authorization URL for the given request type.
	///
	/// Appends `token`, `redirectTo`, and `operation` query items to the configured
	/// `webAuthorizationUrl`. Falls back to ``URL/empty`` if the configuration is unavailable.
	///
	/// - Parameters:
	///   - request: The ``StartAuthorizationRequest`` determining the `operation` parameter (`"reg"` or `"auth"`).
	///   - redirectScheme: The URL scheme the server should redirect to after authorization.
	/// - Returns: The fully-constructed web authorization URL.
	func urlForWebAuthorization(for request: StartAuthorizationRequest, redirectScheme: String) -> URL {
		guard let config = try? configurationLoader.config else {
			return .empty
		}

		let operation =
			switch request {
				case .credentialRegistrationViaWeb:
					"reg"
				case .credentialAssertionViaWeb:
					"auth"
				default:
					""
			}

		return config.webAuthorizationUrl.appending(queryItems: [
			.init(name: "token", value: config.accessToken),
			.init(name: "redirectTo", value: redirectScheme),
			.init(name: "operation", value: operation),
		])
	}
}

// MARK: - Preview

extension StartAuthorizationUseCaseImpl {
	/// A pre-configured instance used for SwiftUI previews.
	static var preview: some StartAuthorizationUseCase {
		StartAuthorizationUseCasePreview()
	}
}

/// A no-op preview implementation of ``StartAuthorizationUseCase``.
final class StartAuthorizationUseCasePreview: StartAuthorizationUseCase {
	/// Returns an immediately-completing empty publisher. Used for SwiftUI previews only.
	///
	/// - Parameter type: Ignored.
	/// - Returns: An empty publisher that completes without emitting values.
	func execute(_: StartAuthorizationRequest) -> AnyPublisher<StartAuthorizationResponse, AppError> {
		Empty<StartAuthorizationResponse, AppError>().eraseToAnyPublisher()
	}
}

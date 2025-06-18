//
// FIDO2 Example
//
// Copyright © 2025 Nevis Security AG. All rights reserved.
//

import Combine
import Foundation

final class StartAuthorizationUseCaseImpl {
	private let configurationLoader: ConfigurationLoader
	private let fido2Repository: Fido2Repository
	private let authenticationService: AuthorizationService

	init(configurationLoader: ConfigurationLoader, fido2Repository: Fido2Repository, authenticationService: AuthorizationService) {
		self.configurationLoader = configurationLoader
		self.fido2Repository = fido2Repository
		self.authenticationService = authenticationService
	}
}

// MARK: - StartAuthorizationUseCase

extension StartAuthorizationUseCaseImpl: StartAuthorizationUseCase {
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
	func urlForWebAuthorization(for request: StartAuthorizationRequest, redirectScheme: String) -> URL {
		guard let config = try? configurationLoader.config else {
			return .empty
		}

		let operation = switch request {
		case .credentialRegistrationViaWeb:
			"reg"
		case .credentialAssertionViaWeb:
			"auth"
		default:
			""
		}

		return config.webAuthorizationUrl.appending(queryItems:
			[
				.init(name: "token", value: config.accessToken),
				.init(name: "redirectTo", value: redirectScheme),
				.init(name: "operation", value: operation),
			])
	}
}

// MARK: - Preview

extension StartAuthorizationUseCaseImpl {
	static var preview: some StartAuthorizationUseCase {
		StartAuthorizationUseCasePreview()
	}
}

final class StartAuthorizationUseCasePreview: StartAuthorizationUseCase {
	func execute(_: StartAuthorizationRequest) -> AnyPublisher<StartAuthorizationResponse, AppError> {
		Empty<StartAuthorizationResponse, AppError>().eraseToAnyPublisher()
	}
}

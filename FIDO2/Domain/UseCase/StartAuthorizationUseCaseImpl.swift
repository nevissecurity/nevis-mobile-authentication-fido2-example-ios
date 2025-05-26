//
// FIDO2 Example
//
// Copyright © 2025 Nevis Security AG. All rights reserved.
//

import Combine

final class StartAuthorizationUseCaseImpl {
	private let fido2Repository: Fido2Repository
	private let authenticationService: AuthorizationService

	init(fido2Repository: Fido2Repository, authenticationService: AuthorizationService) {
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
		case let .webAuthorization(url, callbackUrlScheme):
			{
				authenticationService.startWeb(url: url, callbackUrlScheme: callbackUrlScheme)
				return Just(.webAuthorization)
					.setFailureType(to: AppError.self)
					.eraseToAnyPublisher()
			}()
		}
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

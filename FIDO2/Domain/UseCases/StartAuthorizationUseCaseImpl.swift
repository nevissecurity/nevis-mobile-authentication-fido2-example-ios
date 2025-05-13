//
// FIDO2 Example App
//
// Copyright © 2025 Nevis Security AG. All rights reserved.
//

import Combine

final class StartAuthorizationUseCaseImpl {
	private let fido2Repository: Fido2Repository

	init(fido2Repository: Fido2Repository) {
		self.fido2Repository = fido2Repository
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

//
// FIDO2 Example App
//
// Copyright © 2025 Nevis Security AG. All rights reserved.
//

import Combine

final class CompleteAuthorizationUseCaseImpl {
	private let fido2Repository: Fido2Repository

	init(fido2Repository: Fido2Repository) {
		self.fido2Repository = fido2Repository
	}
}

// MARK: - CompleteAuthorizationUseCase

extension CompleteAuthorizationUseCaseImpl: CompleteAuthorizationUseCase {
	func execute(_ type: CompleteAuthorizationRequest) -> AnyPublisher<(), AppError> {
		switch type {
		case let .credentialRegistration(username, statusToken, asResult):
			fido2Repository.completeRegistration(username: username, statusToken: statusToken, asResult: asResult)
		case let .credentialAssertion(statusToken, asResult):
			fido2Repository.completeApproval(statusToken: statusToken, asResult: asResult)
		}
	}
}

// MARK: - Preview

extension CompleteAuthorizationUseCaseImpl {
	static var preview: some CompleteAuthorizationUseCase {
		CompleteAuthorizationUseCasePreview()
	}
}

final class CompleteAuthorizationUseCasePreview: CompleteAuthorizationUseCase {
	func execute(_: CompleteAuthorizationRequest) -> AnyPublisher<(), AppError> {
		Empty<(), AppError>()
			.eraseToAnyPublisher()
	}
}

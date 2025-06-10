//
// FIDO2 Example
//
// Copyright © 2025 Nevis Security AG. All rights reserved.
//

import Combine

final class IntrospectUseCaseImpl {
	private let fido2Repository: Fido2Repository

	init(fido2Repository: Fido2Repository) {
		self.fido2Repository = fido2Repository
	}
}

// MARK: - IntrospectUseCase

extension IntrospectUseCaseImpl: IntrospectUseCase {
	func execute(token: String) -> AnyPublisher<IntrospectInfo, AppError> {
		fido2Repository.introspect(token: token)
	}
}

// MARK: - Preview

extension IntrospectUseCaseImpl {
	static var preview: some IntrospectUseCase {
		IntrospectUseCasePreview()
	}
}

final class IntrospectUseCasePreview: IntrospectUseCase {
	func execute(token _: String) -> AnyPublisher<IntrospectInfo, AppError> {
		Empty<IntrospectInfo, AppError>().eraseToAnyPublisher()
	}
}

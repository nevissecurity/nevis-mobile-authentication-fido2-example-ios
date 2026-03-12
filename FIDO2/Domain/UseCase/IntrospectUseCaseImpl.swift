//
// FIDO2 Example
//
// Copyright © 2026 Nevis Security AG. All rights reserved.
//

import Combine

/// Concrete implementation of ``IntrospectUseCase``.
final class IntrospectUseCaseImpl {
	/// Used to introspect JWT tokens against the Authentication Cloud.
	private let fido2Repository: Fido2Repository

	/// Creates an instance backed by the given repository.
	///
	/// - Parameter fido2Repository: The repository used to perform the introspect network call.
	init(fido2Repository: Fido2Repository) {
		self.fido2Repository = fido2Repository
	}
}

// MARK: - IntrospectUseCase

extension IntrospectUseCaseImpl: IntrospectUseCase {
	/// Introspects the token by delegating to ``Fido2Repository/introspect(token:)``.
	///
	/// - Parameter token: The JWT string to validate.
	/// - Returns: A publisher that emits ``IntrospectInfo`` or fails with ``AppError``.
	func execute(token: String) -> AnyPublisher<IntrospectInfo, AppError> {
		fido2Repository.introspect(token: token)
	}
}

// MARK: - Preview

extension IntrospectUseCaseImpl {
	/// A pre-configured instance used for SwiftUI previews.
	static var preview: some IntrospectUseCase {
		IntrospectUseCasePreview()
	}
}

/// A no-op preview implementation of ``IntrospectUseCase``.
final class IntrospectUseCasePreview: IntrospectUseCase {
	/// Returns an immediately-completing empty publisher. Used for SwiftUI previews only.
	///
	/// - Parameter token: Ignored.
	/// - Returns: An empty publisher that completes without emitting values.
	func execute(token _: String) -> AnyPublisher<IntrospectInfo, AppError> {
		Empty<IntrospectInfo, AppError>().eraseToAnyPublisher()
	}
}

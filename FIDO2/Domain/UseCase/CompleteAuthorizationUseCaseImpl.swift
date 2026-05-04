//
// FIDO2 Example
//
// Copyright © 2026 Nevis Security AG. All rights reserved.
//

import Combine

/// Concrete implementation of ``CompleteAuthorizationUseCase``.
final class CompleteAuthorizationUseCaseImpl {
	/// Used to complete registration and authentication ceremonies with the Authentication Cloud.
	private let fido2Repository: Fido2Repository

	/// Creates an instance backed by the given repository.
	///
	/// - Parameter fido2Repository: The repository used to complete registration and authentication ceremonies.
	init(fido2Repository: Fido2Repository) {
		self.fido2Repository = fido2Repository
	}
}

// MARK: - CompleteAuthorizationUseCase

extension CompleteAuthorizationUseCaseImpl: CompleteAuthorizationUseCase {
	/// Routes to the correct repository completion method:
	/// - `.credentialRegistration` → ``Fido2Repository/completeRegistration(deviceName:statusToken:authorizationResult:)``
	/// - `.credentialAssertion` → ``Fido2Repository/completeApproval(statusToken:authorizationResult:)``
	/// - `.completedWebAuthorization` → handled by the view model directly; calling this with that case is a programming error.
	func execute(_ type: CompleteAuthorizationRequest) -> AnyPublisher<AuthorizationToken, AppError> {
		switch type {
			case let .credentialRegistration(deviceName, statusToken, asResult):
				fido2Repository.completeRegistration(deviceName: deviceName, statusToken: statusToken, authorizationResult: asResult)
			case let .credentialAssertion(statusToken, asResult):
				fido2Repository.completeApproval(statusToken: statusToken, authorizationResult: asResult)
			default:
				fatalError("Invalid type")
		}
	}
}

// MARK: - Preview

extension CompleteAuthorizationUseCaseImpl {
	/// A pre-configured instance used for SwiftUI previews.
	static var preview: some CompleteAuthorizationUseCase {
		CompleteAuthorizationUseCasePreview()
	}
}

/// A no-op preview implementation of ``CompleteAuthorizationUseCase``.
final class CompleteAuthorizationUseCasePreview: CompleteAuthorizationUseCase {
	/// Returns an immediately-completing empty publisher. Used for SwiftUI previews only.
	///
	/// - Parameter _: Ignored.
	/// - Returns: An empty publisher that completes without emitting values.
	func execute(_: CompleteAuthorizationRequest) -> AnyPublisher<AuthorizationToken, AppError> {
		Empty<AuthorizationToken, AppError>()
			.eraseToAnyPublisher()
	}
}

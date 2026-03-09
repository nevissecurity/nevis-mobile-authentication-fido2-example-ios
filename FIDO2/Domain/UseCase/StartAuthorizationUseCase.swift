//
// FIDO2 Example
//
// Copyright © 2026 Nevis Security AG. All rights reserved.
//

import Combine

/// Initiates a FIDO2 or web authorization flow.
protocol StartAuthorizationUseCase {
	/// Starts the authorization flow described by `type`.
	///
	/// For passkey flows, contacts the server to obtain a challenge, then triggers
	/// the appropriate `ASAuthorizationController` request via ``AuthorizationService``.
	/// For web flows, opens an `ASWebAuthenticationSession` directly.
	///
	/// - Parameter type: The type of authorization to begin.
	/// - Returns: A publisher that emits a ``StartAuthorizationResponse`` describing the next step,
	///   or fails with an ``AppError``.
	func execute(_ type: StartAuthorizationRequest) -> AnyPublisher<StartAuthorizationResponse, AppError>
}

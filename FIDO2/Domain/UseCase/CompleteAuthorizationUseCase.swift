//
// FIDO2 Example
//
// Copyright © 2026 Nevis Security AG. All rights reserved.
//

import Combine

/// Completes a FIDO2 authorization by submitting the credential result to the server.
protocol CompleteAuthorizationUseCase {
	/// Submits the result of the system passkey UI to the server and returns an authorization token.
	///
	/// - Parameter type: The completion data, containing the status token and raw credential bytes.
	/// - Returns: A publisher that emits an ``AuthorizationToken`` (JWT) or fails with an ``AppError``.
	func execute(_ type: CompleteAuthorizationRequest) -> AnyPublisher<AuthorizationToken, AppError>
}

//
// FIDO2 Example
//
// Copyright © 2026 Nevis Security AG. All rights reserved.
//

import Combine

/// Validates a JWT authorization token and retrieves its claims.
protocol IntrospectUseCase {
	/// Introspects the given token against the Authentication Cloud introspection endpoint.
	///
	/// - Parameter token: The JWT string to validate.
	/// - Returns: A publisher that emits ``IntrospectInfo`` with the token's active status and claims,
	///   or fails with an ``AppError``.
	func execute(token: String) -> AnyPublisher<IntrospectInfo, AppError>
}

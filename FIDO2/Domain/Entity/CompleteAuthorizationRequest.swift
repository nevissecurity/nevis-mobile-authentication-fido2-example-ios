//
// FIDO2 Example
//
// Copyright © 2026 Nevis Security AG. All rights reserved.
//

/// Describes the input to ``CompleteAuthorizationUseCase``.
///
/// Each case corresponds to a different completion path after the system passkey
/// UI or web session has returned a result.
enum CompleteAuthorizationRequest {
	/// Completes a passkey registration ceremony.
	///
	/// - Parameters:
	///   - deviceName: A human-readable name for the registering device.
	///   - statusToken: The session token from the server's enroll response.
	///   - authorizationResult: The raw credential bytes from the registration ceremony.
	case credentialRegistration(deviceName: String, statusToken: String, authorizationResult: AuthorizationResult)

	/// Completes a passkey authentication ceremony.
	///
	/// - Parameters:
	///   - statusToken: The session token from the server's approval response.
	///   - authorizationResult: The raw assertion bytes from the authentication ceremony.
	case credentialAssertion(statusToken: String, authorizationResult: AuthorizationResult)

	/// Signals that the web-based OAuth/OIDC flow completed and already carries the token.
	///
	/// This case is handled directly by the view model without calling the complete use case.
	///
	/// - Parameter authorizationToken: The JWT returned in the web callback URL.
	case completedWebAuthorization(authorizationToken: String)
}

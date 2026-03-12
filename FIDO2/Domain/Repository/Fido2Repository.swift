//
// FIDO2 Example
//
// Copyright © 2026 Nevis Security AG. All rights reserved.
//

import Combine

/// Abstracts all FIDO2 network operations against the Authentication Cloud backend.
///
/// Implementations are responsible for mapping between domain entities and the
/// network DTO layer.
protocol Fido2Repository {
	/// Initiates a passkey registration ceremony for the given user.
	///
	/// POSTs to `/api/v1/users/enroll` and returns the server-provided
	/// `CredentialCreationOptions` mapped to a ``StartAuthorizationResponse``.
	///
	/// - Parameters:
	///   - username: The username to enroll.
	///   - fido2Options: FIDO2 policy overrides (user verification, attestation, etc.).
	/// - Returns: A publisher that emits a ``StartAuthorizationResponse/credentialRegistration(username:statusToken:authorizationCreationOption:)`` or fails with ``AppError``.
	func startRegistration(username: String, fido2Options: Fido2Options) -> AnyPublisher<StartAuthorizationResponse, AppError>

	/// Submits the attestation object to the server to complete registration.
	///
	/// POSTs Base64URL-encoded credential data to `/_app/attestation/result`.
	///
	/// - Parameters:
	///   - deviceName: A human-readable name for the device being registered.
	///   - statusToken: The session token returned by ``startRegistration(username:fido2Options:)``.
	///   - authorizationResult: The raw credential bytes from `ASAuthorizationController`.
	/// - Returns: A publisher that emits an ``AuthorizationToken`` (JWT) or fails with ``AppError``.
	func completeRegistration(deviceName: String, statusToken: String, authorizationResult: AuthorizationResult) -> AnyPublisher<AuthorizationToken, AppError>

	/// Initiates a passkey authentication ceremony.
	///
	/// POSTs to `/api/v1/approval` and returns the server-provided
	/// `CredentialRequestOptions` mapped to a ``StartAuthorizationResponse``.
	///
	/// - Parameters:
	///   - username: The username to authenticate, or `nil` for usernameless/discoverable flow.
	///   - fido2Options: Optional FIDO2 policy overrides.
	/// - Returns: A publisher that emits a ``StartAuthorizationResponse/credentialAssertion(statusToken:authorizationCreationOption:)`` or fails with ``AppError``.
	func startApproval(username: String?, fido2Options: Fido2Options?) -> AnyPublisher<StartAuthorizationResponse, AppError>

	/// Submits the assertion response to the server to complete authentication.
	///
	/// POSTs Base64URL-encoded assertion data to `/_app/assertion/result`.
	///
	/// - Parameters:
	///   - statusToken: The session token returned by ``startApproval(username:fido2Options:)``.
	///   - authorizationResult: The raw assertion bytes from `ASAuthorizationController`.
	/// - Returns: A publisher that emits an ``AuthorizationToken`` (JWT) or fails with ``AppError``.
	func completeApproval(statusToken: String, authorizationResult: AuthorizationResult) -> AnyPublisher<AuthorizationToken, AppError>

	/// Introspects a JWT authorization token.
	///
	/// POSTs to `/api/v1/introspect` and returns the token's active status and claims.
	///
	/// - Parameter token: The JWT string to introspect.
	/// - Returns: A publisher that emits ``IntrospectInfo`` or fails with ``AppError``.
	func introspect(token: String) -> AnyPublisher<IntrospectInfo, AppError>
}

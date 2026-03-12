//
// FIDO2 Example
//
// Copyright © 2026 Nevis Security AG. All rights reserved.
//

import Combine
import Moya

/// Abstracts the low-level HTTP transport for Authentication Cloud API calls.
///
/// Each method corresponds to a single API endpoint and returns a typed Combine publisher.
/// The Moya layer handles request serialization, response deserialization, and Bearer authentication.
protocol AuthenticationCloudDataSource {
	/// The HTTP User-Agent header value used for all requests.
	var userAgent: String { get }

	/// Initiates passkey registration — POST `/api/v1/users/enroll`.
	///
	/// - Parameter request: The registration request DTO.
	/// - Returns: A publisher that emits a ``RegistrationResponse`` or fails with `MoyaError`.
	func registration(request: RegistrationRequest) -> AnyPublisher<RegistrationResponse, MoyaError>

	/// Completes passkey registration — POST `/_app/attestation/result`.
	///
	/// - Parameter request: The attestation request DTO containing Base64URL-encoded credential data.
	/// - Returns: A publisher that emits an ``AttestationResponse`` or fails with `MoyaError`.
	func attestation(request: AttestationRequest) -> AnyPublisher<AttestationResponse, MoyaError>

	/// Initiates passkey authentication — POST `/api/v1/approval`.
	///
	/// - Parameter request: The approval request DTO.
	/// - Returns: A publisher that emits an ``ApprovalResponse`` or fails with `MoyaError`.
	func approval(request: ApprovalRequest) -> AnyPublisher<ApprovalResponse, MoyaError>

	/// Completes passkey authentication — POST `/_app/assertion/result`.
	///
	/// - Parameter request: The assertion request DTO containing Base64URL-encoded assertion data.
	/// - Returns: A publisher that emits an ``AssertionResponse`` or fails with `MoyaError`.
	func assertion(request: AssertionRequest) -> AnyPublisher<AssertionResponse, MoyaError>

	/// Introspects a JWT token — POST `/api/v1/introspect`.
	///
	/// - Parameter request: The introspect request DTO with the token to validate.
	/// - Returns: A publisher that emits an ``IntrospectResponse`` or fails with `MoyaError`.
	func introspect(request: IntrospectRequest) -> AnyPublisher<IntrospectResponse, MoyaError>

	/// Extracts a human-readable error message from a `MoyaError`.
	///
	/// Attempts to decode the response body as an ``ErrorResponse`` for structured error messages;
	/// falls back to the localized description for other error types.
	///
	/// - Parameter moyaError: The Moya error to inspect.
	/// - Returns: A descriptive error string, or `nil` if no message is available.
	func errorMessage(from moyaError: MoyaError) -> String?
}

//
// FIDO2 Example
//
// Copyright © 2026 Nevis Security AG. All rights reserved.
//

import Combine
import Moya

/// Concrete implementation of ``Fido2Repository``.
///
/// Translates domain calls into ``AuthenticationCloudDataSource`` network requests
/// and maps the resulting DTOs back to domain entities or ``AppError`` values.
final class Fido2RepositoryImpl {
	/// The data source used for all Authentication Cloud network requests.
	private let authenticationCloudDataSource: AuthenticationCloudDataSource

	/// Creates an instance that uses the given data source for all network operations.
	///
	/// - Parameter authenticationCloudDataSource: The data source to use for Authentication Cloud requests.
	init(authenticationCloudDataSource: AuthenticationCloudDataSource) {
		self.authenticationCloudDataSource = authenticationCloudDataSource
	}
}

// MARK: - Fido2Repository

extension Fido2RepositoryImpl: Fido2Repository {
	// MARK: Registration

	/// Initiates passkey registration for `username` by calling ``AuthenticationCloudDataSource/registration(request:)``.
	///
	/// - Parameters:
	///   - username: The username to enroll.
	///   - fido2Options: FIDO2 policy overrides sent to the server.
	/// - Returns: A publisher that emits a ``StartAuthorizationResponse`` or fails with ``AppError``.
	func startRegistration(username: String, fido2Options: Fido2Options) -> AnyPublisher<StartAuthorizationResponse, AppError> {
		let request = RegistrationRequest(
			username: username,
			displayName: username,
			fido2Options: .map(from: fido2Options),
		)

		return authenticationCloudDataSource.registration(request: request)
			.tryMap { registrationResponse -> StartAuthorizationResponse in
				try registrationResponse.map(username: username).get()
			}
			.mapError(mapError)
			.eraseToAnyPublisher()
	}

	/// Completes passkey registration by submitting the attestation object to the server.
	///
	/// - Parameters:
	///   - deviceName: A human-readable name for the registering device.
	///   - statusToken: The session token from the server's enroll response.
	///   - authorizationResult: The raw credential bytes returned by `ASAuthorizationController`.
	/// - Returns: A publisher that emits an ``AuthorizationToken`` (JWT) or fails with ``AppError``.
	func completeRegistration(deviceName: String, statusToken: String, authorizationResult: AuthorizationResult) -> AnyPublisher<AuthorizationToken, AppError> {
		guard let rawAttestationObject = authorizationResult.rawAttestationObject else {
			return Fail(error: AppError.missingData(message: "Invalid attestation object received")).eraseToAnyPublisher()
		}

		let request = AttestationRequest(
			type: "public-key",
			id: authorizationResult.credentialID.toBase64UrlEncodedString(),
			response: EnrollmentData(
				attestationObject: rawAttestationObject.toBase64UrlEncodedString(),
				clientDataJSON: authorizationResult.rawClientDataJSON.toBase64UrlEncodedString(),
			),
			statusToken: statusToken,
			userFriendlyName: deviceName,
			userAgent: authenticationCloudDataSource.userAgent,
		)

		return authenticationCloudDataSource.attestation(request: request)
			.tryMap { attestationResponse in
				try attestationResponse.map().get()
			}
			.mapError(mapError)
			.eraseToAnyPublisher()
	}

	// MARK: Approval

	/// Initiates passkey authentication by calling ``AuthenticationCloudDataSource/approval(request:)``.
	///
	/// - Parameters:
	///   - username: The username to authenticate, or `nil` for a usernameless/discoverable flow.
	///   - fido2Options: Optional FIDO2 policy overrides.
	/// - Returns: A publisher that emits a ``StartAuthorizationResponse`` or fails with ``AppError``.
	func startApproval(username: String? = nil, fido2Options: Fido2Options?) -> AnyPublisher<StartAuthorizationResponse, AppError> {
		let request = ApprovalRequest(
			username: username,
			fido2Options: .map(from: fido2Options),
		)

		return authenticationCloudDataSource.approval(request: request)
			.tryMap { approvalResponse -> StartAuthorizationResponse in
				try approvalResponse.map(username: username).get()
			}
			.mapError(mapError)
			.eraseToAnyPublisher()
	}

	/// Completes passkey authentication by submitting the assertion response to the server.
	///
	/// - Parameters:
	///   - statusToken: The session token from the server's approval response.
	///   - authorizationResult: The raw assertion bytes returned by `ASAuthorizationController`.
	/// - Returns: A publisher that emits an ``AuthorizationToken`` (JWT) or fails with ``AppError``.
	func completeApproval(statusToken: String, authorizationResult: AuthorizationResult) -> AnyPublisher<AuthorizationToken, AppError> {
		guard let rawAuthenticatorData = authorizationResult.rawAuthenticatorData else {
			return Fail(error: AppError.missingData(message: "Invalid attestation object received")).eraseToAnyPublisher()
		}
		guard let signature = authorizationResult.signature else {
			return Fail(error: AppError.missingData(message: "Invalid signature object received")).eraseToAnyPublisher()
		}
		guard let userID = authorizationResult.userID else {
			return Fail(error: AppError.missingData(message: "Invalid userID object received")).eraseToAnyPublisher()
		}

		let request = AssertionRequest(
			type: "public-key",
			id: authorizationResult.credentialID.toBase64UrlEncodedString(),
			response: .init(
				authenticatorData: rawAuthenticatorData.toBase64UrlEncodedString(),
				clientDataJSON: authorizationResult.rawClientDataJSON.toBase64UrlEncodedString(),
				signature: signature.toBase64UrlEncodedString(),
				userHandle: userID.toBase64UrlEncodedString(),
			),
			statusToken: statusToken,
			userAgent: authenticationCloudDataSource.userAgent,
		)

		return authenticationCloudDataSource.assertion(request: request)
			.tryMap { assertionResponse in
				try assertionResponse.map().get()
			}
			.mapError(mapError)
			.eraseToAnyPublisher()
	}

	// MARK: Introspection

	/// Introspects a JWT token by forwarding it to ``AuthenticationCloudDataSource/introspect(request:)``.
	///
	/// - Parameter token: The JWT string to validate.
	/// - Returns: A publisher that emits ``IntrospectInfo`` or fails with ``AppError``.
	func introspect(token: String) -> AnyPublisher<IntrospectInfo, AppError> {
		let request = IntrospectRequest(token: token)
		return authenticationCloudDataSource.introspect(request: request)
			.map { introspectResponse in
				introspectResponse.map()
			}
			.mapError(mapError)
			.eraseToAnyPublisher()
	}
}

// MARK: - Error mapping

private extension Fido2RepositoryImpl {
	/// Converts any `Error` into an ``AppError``.
	///
	/// Already-wrapped ``AppError`` values are returned as-is. `MoyaError` is converted to
	/// ``AppError/network(message:underlying:)`` with the human-readable message from the data source.
	/// All other errors become ``AppError/unknown(message:underlying:)``.
	///
	/// - Parameter error: The error to convert.
	/// - Returns: The corresponding ``AppError``.
	func mapError(_ error: Error) -> AppError {
		if let fido2RepositoryError = error as? AppError {
			return fido2RepositoryError
		}

		return switch error {
			case let moyaError as MoyaError:
				.network(message: authenticationCloudDataSource.errorMessage(from: moyaError), underlying: moyaError)
			default:
				.unknown(underlying: error)
		}
	}
}

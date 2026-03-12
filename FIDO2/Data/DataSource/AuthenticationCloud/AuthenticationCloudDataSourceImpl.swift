//
// FIDO2 Example
//
// Copyright © 2026 Nevis Security AG. All rights reserved.
//

import Combine
import Foundation
import Moya

/// Concrete implementation of ``AuthenticationCloudDataSource`` backed by a
/// `MoyaProvider<AuthenticationCloud>`.
final class AuthenticationCloudDataSourceImpl {
	/// The Moya provider used to send all Authentication Cloud requests.
	private let provider: MoyaProvider<AuthenticationCloud>

	/// Creates an instance backed by the given Moya provider.
	///
	/// - Parameter provider: A configured `MoyaProvider<AuthenticationCloud>` used to send requests.
	init(provider: MoyaProvider<AuthenticationCloud>) {
		self.provider = provider
	}
}

// MARK: - AuthenticationCloudDataSource

extension AuthenticationCloudDataSourceImpl: AuthenticationCloudDataSource {
	/// The HTTP `User-Agent` header value forwarded from the underlying Moya provider.
	var userAgent: String {
		provider.userAgent
	}

	/// Initiates passkey registration by forwarding the request to the ``AuthenticationCloud/registration(request:)`` endpoint.
	///
	/// - Parameter request: The registration request DTO.
	/// - Returns: A publisher that emits a ``RegistrationResponse`` or fails with `MoyaError`.
	func registration(request: RegistrationRequest) -> AnyPublisher<RegistrationResponse, MoyaError> {
		execute(target: .registration(request: request))
	}

	/// Completes passkey registration by forwarding the request to the ``AuthenticationCloud/attestation(request:)`` endpoint.
	///
	/// - Parameter request: The attestation request DTO.
	/// - Returns: A publisher that emits an ``AttestationResponse`` or fails with `MoyaError`.
	func attestation(request: AttestationRequest) -> AnyPublisher<AttestationResponse, MoyaError> {
		execute(target: .attestation(request: request))
	}

	/// Initiates passkey authentication by forwarding the request to the ``AuthenticationCloud/approval(request:)`` endpoint.
	///
	/// - Parameter request: The approval request DTO.
	/// - Returns: A publisher that emits an ``ApprovalResponse`` or fails with `MoyaError`.
	func approval(request: ApprovalRequest) -> AnyPublisher<ApprovalResponse, MoyaError> {
		execute(target: .approval(request: request))
	}

	/// Completes passkey authentication by forwarding the request to the ``AuthenticationCloud/assertion(request:)`` endpoint.
	///
	/// - Parameter request: The assertion request DTO.
	/// - Returns: A publisher that emits an ``AssertionResponse`` or fails with `MoyaError`.
	func assertion(request: AssertionRequest) -> AnyPublisher<AssertionResponse, MoyaError> {
		execute(target: .assertion(request: request))
	}

	/// Introspects a JWT token by forwarding the request to the ``AuthenticationCloud/introspect(request:)`` endpoint.
	///
	/// - Parameter request: The introspect request DTO.
	/// - Returns: A publisher that emits an ``IntrospectResponse`` or fails with `MoyaError`.
	func introspect(request: IntrospectRequest) -> AnyPublisher<IntrospectResponse, MoyaError> {
		execute(target: .introspect(request: request))
	}

	/// Extracts a human-readable error message from a `MoyaError`.
	///
	/// Attempts to decode the response body as ``ErrorResponse``; falls back to the status code
	/// and URL string, or to `localizedDescription` for non-status-code errors.
	///
	/// - Parameter moyaError: The Moya error to inspect.
	/// - Returns: A descriptive string, or `nil` if no message can be extracted.
	func errorMessage(from moyaError: Moya.MoyaError) -> String? {
		guard case let .statusCode(response) = moyaError else {
			return moyaError.localizedDescription
		}

		guard let errorResponse = try? JSONDecoder().decode(ErrorResponse.self, from: response.data) else {
			return "\(moyaError.localizedDescription): \(response.statusCode) \(response.request?.url?.absoluteString ?? "")"
		}

		return errorResponse.message?
			.replacingOccurrences(of: "\\'", with: "'")
			.replacingOccurrences(of: "\\\"", with: "\"")
	}
}

// MARK: - Execute using Publisher

private extension AuthenticationCloudDataSourceImpl {
	/// Sends `target` to the Moya provider and decodes the response body as `T`.
	///
	/// Validates the HTTP status code (200–299) before attempting JSON decoding.
	/// Any non-Moya error from the decoding step is wrapped in `MoyaError.underlying`.
	///
	/// - Parameter target: The ``AuthenticationCloud`` endpoint to call.
	/// - Returns: A publisher that emits a decoded `T` or fails with `MoyaError`.
	func execute<T: Decodable>(target: AuthenticationCloud) -> AnyPublisher<T, MoyaError> {
		provider.requestPublisher(target)
			.tryMap { response -> T in
				guard (200 ... 299).contains(response.statusCode) else {
					// Non-2xx status: wrap as a status code error so callers can inspect the body.
					throw MoyaError.statusCode(response)
				}
				return try JSONDecoder().decode(T.self, from: response.data)
			}
			.mapError { error in
				error as? MoyaError ?? MoyaError.underlying(error, nil)
			}
			.eraseToAnyPublisher()
	}
}

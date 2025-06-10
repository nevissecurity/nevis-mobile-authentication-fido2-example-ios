//
// FIDO2 Example
//
// Copyright © 2025 Nevis Security AG. All rights reserved.
//

import Combine
import Moya

final class Fido2RepositoryImpl {
	private let authenticationCloudDataSource: AuthenticationCloudDataSource

	init(authenticationCloudDataSource: AuthenticationCloudDataSource) {
		self.authenticationCloudDataSource = authenticationCloudDataSource
	}
}

// MARK: - Fido2Repository

extension Fido2RepositoryImpl: Fido2Repository {
	// MARK: Registration

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

//
// FIDO2 Example App
//
// Copyright © 2025 Nevis Security AG. All rights reserved.
//

import AuthenticationServices
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
			fido2Options: RegistrationFido2Options(from: fido2Options)
		)

		return authenticationCloudDataSource.registrtion(request: request)
			.tryMap { registrationResponse -> StartAuthorizationResponse in
				try registrationResponse.toDomain(username: username).get()
			}
			.mapError(mapError)
			.eraseToAnyPublisher()
	}

	func completeRegistration(username: String, statusToken: String, asResult: ASAuthorizationPlatformPublicKeyCredentialRegistration) -> AnyPublisher<(), AppError> {
		guard let rawAttestationObject = asResult.rawAttestationObject?.toBase64UrlEncodedString() else {
			return Fail(error: AppError.missingData(message: "Invalid attestation object received")).eraseToAnyPublisher()
		}

		let request = AttestationRequest(
			type: "public-key",
			id: asResult.credentialID.toBase64UrlEncodedString(),
			response: EnrollmentData(
				attestationObject: rawAttestationObject,
				clientDataJSON: asResult.rawClientDataJSON.toBase64UrlEncodedString()
			),
			statusToken: statusToken,
			userFriendlyName: username,
			userAgent: authenticationCloudDataSource.userAgent,
		)

		return authenticationCloudDataSource.attestation(request: request)
			.tryMap { attestationResponse in
				try attestationResponse.toDomain().get()
			}
			.mapError(mapError)
			.eraseToAnyPublisher()
	}

	// MARK: Approval

	func startApproval(username: String? = nil, fido2Options: Fido2Options?) -> AnyPublisher<StartAuthorizationResponse, AppError> {
		let request = ApprovalRequest(
			username: username,
			fido2Options: ApprovalFido2Options(from: fido2Options)
		)

		return authenticationCloudDataSource.approval(request: request)
			.tryMap { approvalResponse -> StartAuthorizationResponse in
				try approvalResponse.toDomain(username: username).get()
			}
			.mapError(mapError)
			.eraseToAnyPublisher()
	}

	func completeApproval(statusToken: String, asResult: ASAuthorizationPlatformPublicKeyCredentialAssertion) -> AnyPublisher<(), AppError> {
		let request = AssertionRequest(
			type: "public-key",
			id: asResult.credentialID.toBase64UrlEncodedString(),
			response: .init(
				authenticatorData: asResult.rawAuthenticatorData.toBase64UrlEncodedString(),
				clientDataJSON: asResult.rawClientDataJSON.toBase64UrlEncodedString(),
				signature: asResult.signature.toBase64UrlEncodedString(),
				userHandle: asResult.userID.toBase64UrlEncodedString()
			),
			statusToken: statusToken,
			userAgent: authenticationCloudDataSource.userAgent,
		)

		return authenticationCloudDataSource.assertion(request: request)
			.tryMap { assertionResponse in
				try assertionResponse.toDomain().get()
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

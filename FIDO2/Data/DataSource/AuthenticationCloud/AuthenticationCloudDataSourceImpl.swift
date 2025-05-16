//
// FIDO2 Example
//
// Copyright © 2025 Nevis Security AG. All rights reserved.
//

import Combine
import Foundation
import Moya

final class AuthenticationCloudDataSourceImpl {
	private let provider: MoyaProvider<AuthenticationCloud>

	init(provider: MoyaProvider<AuthenticationCloud>) {
		self.provider = provider
	}
}

// MARK: - AuthenticationCloudDataSource

extension AuthenticationCloudDataSourceImpl: AuthenticationCloudDataSource {
	var userAgent: String {
		provider.userAgent
	}

	func registration(request: RegistrationRequest) -> AnyPublisher<RegistrationResponse, MoyaError> {
		execute(target: .registration(request: request))
	}

	func attestation(request: AttestationRequest) -> AnyPublisher<AttestationResponse, MoyaError> {
		execute(target: .attestation(request: request))
	}

	func approval(request: ApprovalRequest) -> AnyPublisher<ApprovalResponse, MoyaError> {
		execute(target: .approval(request: request))
	}

	func assertion(request: AssertionRequest) -> AnyPublisher<AssertionResponse, MoyaError> {
		execute(target: .assertion(request: request))
	}

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
	func execute<T: Decodable>(target: AuthenticationCloud) -> AnyPublisher<T, MoyaError> {
		provider.requestPublisher(target)
			.tryMap { response -> T in
				guard (200 ... 299).contains(response.statusCode) else {
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

//
// FIDO2 PoC
//
// Copyright © 2025 NEVIS. All rights reserved.
//

import Combine
import Foundation
import Moya
import AuthenticationServices

final class Fido2RepositoryImpl: Fido2Repository {
	private let fireballDataSource: FireballDataSource
	private let fido2AuthenticationManager: Fido2AuthenticationManager

	init(fireballDataSource: FireballDataSource, fido2AuthenticationManager: Fido2AuthenticationManager) {
		self.fireballDataSource = fireballDataSource
		self.fido2AuthenticationManager = fido2AuthenticationManager
	}

	func enroll(username: String) -> AnyPublisher<AsAuthorizationType, Error> {
		let request = StartEnrollRequest(username: username, displayName: username)
		return fireballDataSource.startEnrollment(request: request)
			.tryMap { response -> EnrollResponse in
				response.toDomain()
			}
			.mapError { error in
				if let moyaError = error as? MoyaError {
					print("MoyaError: \(moyaError)")
				} else if let decodingError = error as? DecodingError {
					print("DecodingError: \(decodingError)")
				} else {
					print("Other error: \(error)")
				}
				return error
			}
			.flatMap { [weak self] enrollResponse -> AnyPublisher<ASAuthorization, any Error> in
				guard let self else {
					return Fail(error: AppError.unknown).eraseToAnyPublisher()
				}

				print("Enroll response: \(enrollResponse)")
				return self.fido2AuthenticationManager.enroll(username: username, credentialCreationOptions: enrollResponse.enrollment.credentialCreationOptions)
			}
			// TODO: call fireballDataSource.completeEnrollment(request:) here
			.tryMap({ asAuthorization in
				AsAuthorizationType(asAuthorization)
			})
			.eraseToAnyPublisher()
	}
}

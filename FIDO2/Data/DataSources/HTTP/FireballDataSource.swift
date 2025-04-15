//
// FIDO2 PoC
//
// Copyright © 2025 NEVIS. All rights reserved.
//

import Foundation
import Moya
import Combine

// Extend MoyaProvider to support Combine publishing if not already available
extension MoyaProvider {
	func requestPublisher(_ target: Target) -> AnyPublisher<Response, MoyaError> {
		return Future { [weak self] promise in
			self?.request(target, completion: promise)
		}
		.eraseToAnyPublisher()
	}
}

// TODO: separate this into a protocol + implementation
class FireballDataSource {
	private let provider: MoyaProvider<Fireball>
	
	init(provider: MoyaProvider<Fireball> = MoyaProvider<Fireball>()) {
		self.provider = provider
	}
	
	func startEnrollment(request: StartEnrollRequest) -> AnyPublisher<StartEnrollResponse, MoyaError> {
		return execute(target: .startEnrollment(request: request), decodeTo: StartEnrollResponse.self)
	}
	
	func completeEnrollment(request: CompleteEnrollRequest) -> AnyPublisher<CompleteEnrollResponse, MoyaError> {
		return execute(target: .completeEnrollment(request: request), decodeTo: CompleteEnrollResponse.self)
	}
	
	func startAuthentication(request: StartApprovalRequest) -> AnyPublisher<StartApprovalResponse, MoyaError> {
		return execute(target: .startAuthentication(request: request), decodeTo: StartApprovalResponse.self)
	}
	
	func completeAuthentication(request: CompleteApprovalRequest) -> AnyPublisher<CompleteApprovalResponse, MoyaError> {
		return execute(target: .completeAuthentication(request: request), decodeTo: CompleteApprovalResponse.self)
	}
	
	private func execute<T: Decodable>(target: Fireball, decodeTo type: T.Type) -> AnyPublisher<T, MoyaError> {

		return provider.requestPublisher(target)
			.tryMap { response -> T in
				guard (200...299).contains(response.statusCode) else {
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

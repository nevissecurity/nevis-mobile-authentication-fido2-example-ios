//
// FIDO2 Example
//
// Copyright © 2025 Nevis Security AG. All rights reserved.
//

import Combine

protocol Fido2Repository {
	func startRegistration(username: String, fido2Options: Fido2Options) -> AnyPublisher<StartAuthorizationResponse, AppError>
	func completeRegistration(deviceName: String, statusToken: String, authorizationResult: AuthorizationResult) -> AnyPublisher<AuthorizationToken, AppError>
	func startApproval(username: String?, fido2Options: Fido2Options?) -> AnyPublisher<StartAuthorizationResponse, AppError>
	func completeApproval(statusToken: String, authorizationResult: AuthorizationResult) -> AnyPublisher<AuthorizationToken, AppError>
}

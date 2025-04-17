//
// FIDO2 Example App
//
// Copyright © 2025 Nevis Security AG. All rights reserved.
//

import AuthenticationServices
import Combine

protocol Fido2Repository {
	func startRegistration(username: String) -> AnyPublisher<StartAuthorizationResponse, AppError>
	func completeRegistration(username: String, statusToken: String, asResult: ASAuthorizationPlatformPublicKeyCredentialRegistration) -> AnyPublisher<(), AppError>
	func startApproval(username: String?) -> AnyPublisher<StartAuthorizationResponse, AppError>
	func completeApproval(statusToken: String, asResult: ASAuthorizationPlatformPublicKeyCredentialAssertion) -> AnyPublisher<(), AppError>
}

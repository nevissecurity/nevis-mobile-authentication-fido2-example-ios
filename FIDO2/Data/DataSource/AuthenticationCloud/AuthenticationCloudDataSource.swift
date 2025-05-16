//
// FIDO2 Example
//
// Copyright © 2025 Nevis Security AG. All rights reserved.
//

import Combine
import Moya

protocol AuthenticationCloudDataSource {
	var userAgent: String { get }

	func registration(request: RegistrationRequest) -> AnyPublisher<RegistrationResponse, MoyaError>
	func attestation(request: AttestationRequest) -> AnyPublisher<AttestationResponse, MoyaError>
	func approval(request: ApprovalRequest) -> AnyPublisher<ApprovalResponse, MoyaError>
	func assertion(request: AssertionRequest) -> AnyPublisher<AssertionResponse, MoyaError>

	func errorMessage(from moyaError: MoyaError) -> String?
}

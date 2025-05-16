//
// FIDO2 Example
//
// Copyright © 2025 Nevis Security AG. All rights reserved.
//

import Combine

protocol AuthorizationService {
	var onComplete: AnyPublisher<Result<CompleteAuthorizationRequest, AuthorizationServiceError>, Never> { get }

	func start(_ startAuthorizationResponse: StartAuthorizationResponse, isAutoFillAssisted: Bool)
	func cancel()
}

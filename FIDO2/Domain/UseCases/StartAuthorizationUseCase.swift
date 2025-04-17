//
// FIDO2 Example App
//
// Copyright © 2025 Nevis Security AG. All rights reserved.
//

import Combine

protocol StartAuthorizationUseCase {
	func execute(_ type: StartAuthorizationRequest) -> AnyPublisher<StartAuthorizationResponse, AppError>
}

//
// FIDO2 Example
//
// Copyright © 2025 Nevis Security AG. All rights reserved.
//

import Combine

protocol CompleteAuthorizationUseCase {
	func execute(_ type: CompleteAuthorizationRequest) -> AnyPublisher<AuthorizationToken, AppError>
}

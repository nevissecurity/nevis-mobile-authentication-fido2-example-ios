//
// FIDO2 Example
//
// Copyright © 2025 Nevis Security AG. All rights reserved.
//

import Combine

protocol IntrospectUseCase {
	func execute(token: String) -> AnyPublisher<IntrospectInfo, AppError>
}

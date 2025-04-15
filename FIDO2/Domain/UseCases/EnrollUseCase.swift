//
// FIDO2 PoC
//
// Copyright © 2025 NEVIS. All rights reserved.
//

import Combine
import AuthenticationServices

protocol EnrollUseCase {
	func execute(username: String) -> AnyPublisher<AsAuthorizationType, Error>
}

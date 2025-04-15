//
// FIDO2 PoC
//
// Copyright © 2025 NEVIS. All rights reserved.
//

import Combine
import Foundation

protocol Fido2Repository {
	func enroll(username: String) -> AnyPublisher<AsAuthorizationType, Error>
}

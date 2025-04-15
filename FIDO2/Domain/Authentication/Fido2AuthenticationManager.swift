//
// FIDO2 PoC
//
// Copyright © 2025 NEVIS. All rights reserved.
//

import AuthenticationServices
import Combine
import UIKit

protocol Fido2AuthenticationManager {
	func enroll(username: String, credentialCreationOptions: CredentialCreationOptions) -> AnyPublisher<ASAuthorization, Error>
	func authenticate(credentialRequestOptions: CredentialRequestOptionsDTO) -> AnyPublisher<ASAuthorization, Error>
}

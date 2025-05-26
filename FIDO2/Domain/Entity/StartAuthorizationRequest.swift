//
// FIDO2 Example
//
// Copyright © 2025 Nevis Security AG. All rights reserved.
//

import Foundation

enum StartAuthorizationRequest {
	case credentialRegistration(username: String, fido2Options: Fido2Options)
	case credentialAssertion(username: String? = nil, fido2Options: Fido2Options? = nil)
	case webAuthorization(url: URL, callbackUrlScheme: String)
}

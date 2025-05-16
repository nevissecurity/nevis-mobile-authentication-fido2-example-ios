//
// FIDO2 Example
//
// Copyright © 2025 Nevis Security AG. All rights reserved.
//

enum StartAuthorizationRequest {
	case credentialRegistration(username: String, fido2Options: Fido2Options)
	case credentialAssertion(username: String? = nil, fido2Options: Fido2Options? = nil)
}

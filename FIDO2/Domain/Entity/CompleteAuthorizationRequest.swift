//
// FIDO2 Example
//
// Copyright © 2025 Nevis Security AG. All rights reserved.
//

enum CompleteAuthorizationRequest {
	case credentialRegistration(username: String, statusToken: String, authorizationResult: AuthorizationResult)
	case credentialAssertion(statusToken: String, authorizationResult: AuthorizationResult)
}

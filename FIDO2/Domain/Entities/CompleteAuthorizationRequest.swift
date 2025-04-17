//
// FIDO2 Example App
//
// Copyright © 2025 Nevis Security AG. All rights reserved.
//

import AuthenticationServices

enum CompleteAuthorizationRequest {
	case credentialRegistration(username: String, statusToken: String, asResult: ASAuthorizationPlatformPublicKeyCredentialRegistration)
	case credentialAssertion(statusToken: String, asResult: ASAuthorizationPlatformPublicKeyCredentialAssertion)
}

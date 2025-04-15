//
// FIDO2 PoC
//
// Copyright © 2025 NEVIS. All rights reserved.
//

import AuthenticationServices

/// Enum representing the type of authorization in the FIDO2 protocol.
enum AsAuthorizationType {
	/// The type of authorization for credential registration.
	case credentialRegistration
	/// The type of authorization for credential authentication.
	case credentialAssertion
	
	init(_ type: ASAuthorization) {
		switch type.credential {
		case is ASAuthorizationPlatformPublicKeyCredentialRegistration:
			self = .credentialRegistration
		case is ASAuthorizationPlatformPublicKeyCredentialAssertion:
			self = .credentialAssertion
		default:
			fatalError("Unsupported ASAuthorization type")
		}
	}
}

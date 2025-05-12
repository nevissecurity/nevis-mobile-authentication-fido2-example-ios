//
// FIDO2 Example App
//
// Copyright © 2025 Nevis Security AG. All rights reserved.
//

/// Enum representing the type of authorization in the FIDO2 protocol.
enum StartAuthorizationRequest {
	/// The type of authorization for credential registration.
	case credentialRegistration(username: String, fido2Options: Fido2Options)
	/// The type of authorization for credential authentication.
	case credentialAssertion(username: String? = nil, fido2Options: Fido2Options? = nil)
}

//
// FIDO2 Example
//
// Copyright © 2026 Nevis Security AG. All rights reserved.
//

import Foundation

/// Describes the type of authorization flow the user wants to initiate.
///
/// Passed to ``StartAuthorizationUseCase/execute(_:)`` to begin the appropriate flow.
enum StartAuthorizationRequest {
	/// Starts a passkey registration ceremony for the given user.
	///
	/// - Parameters:
	///   - username: The username to enroll.
	///   - fido2Options: FIDO2 policy overrides.
	case credentialRegistration(username: String, fido2Options: Fido2Options)

	/// Starts a passkey authentication ceremony.
	///
	/// - Parameters:
	///   - username: The username to authenticate, or `nil` for a usernameless/discoverable flow.
	///   - fido2Options: Optional FIDO2 policy overrides.
	case credentialAssertion(username: String? = nil, fido2Options: Fido2Options? = nil)

	/// Starts a web-based registration flow via `ASWebAuthenticationSession`.
	case credentialRegistrationViaWeb

	/// Starts a web-based authentication flow via `ASWebAuthenticationSession`.
	case credentialAssertionViaWeb
}

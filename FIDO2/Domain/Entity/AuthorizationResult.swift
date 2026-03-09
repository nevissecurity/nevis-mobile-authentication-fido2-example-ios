//
// FIDO2 Example
//
// Copyright © 2026 Nevis Security AG. All rights reserved.
//

import AuthenticationServices
import Foundation

/// Carries the raw credential data returned by `ASAuthorizationController` after a
/// successful registration or authentication ceremony.
///
/// Only the fields relevant to the ceremony type will be populated.
struct AuthorizationResult {
	/// The credential identifier assigned by the authenticator.
	let credentialID: Data
	/// The raw client data JSON signed during the ceremony.
	let rawClientDataJSON: Data

	/// The attestation object (registration only).
	var rawAttestationObject: Data?
	/// The authenticator data (assertion only).
	var rawAuthenticatorData: Data?
	/// The authenticator's signature over the challenge and authenticator data (assertion only).
	var signature: Data?
	/// The user handle identifying the credential owner (assertion only).
	var userID: Data?

	// MARK: - Initializers

	/// Creates an `AuthorizationResult` from a platform public key credential registration.
	///
	/// - Parameter credential: The registration credential returned by `ASAuthorizationController`.
	init(from credential: ASAuthorizationPlatformPublicKeyCredentialRegistration) {
		self.credentialID = credential.credentialID
		self.rawClientDataJSON = credential.rawClientDataJSON
		self.rawAttestationObject = credential.rawAttestationObject
	}

	/// Creates an `AuthorizationResult` from a platform public key credential assertion.
	///
	/// - Parameter credential: The assertion credential returned by `ASAuthorizationController`.
	init(from credential: ASAuthorizationPlatformPublicKeyCredentialAssertion) {
		self.credentialID = credential.credentialID
		self.rawClientDataJSON = credential.rawClientDataJSON
		self.rawAuthenticatorData = credential.rawAuthenticatorData
		self.signature = credential.signature
		self.userID = credential.userID
	}
}

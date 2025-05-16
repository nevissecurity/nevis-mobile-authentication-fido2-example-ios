//
// FIDO2 Example
//
// Copyright © 2025 Nevis Security AG. All rights reserved.
//

import AuthenticationServices
import Foundation

struct AuthorizationResult {
	let credentialID: Data
	let rawClientDataJSON: Data

	var rawAttestationObject: Data?
	var rawAuthenticatorData: Data?
	var signature: Data?
	var userID: Data?

	// MARK: - Initializers

	init(from credential: ASAuthorizationPlatformPublicKeyCredentialRegistration) {
		self.credentialID = credential.credentialID
		self.rawClientDataJSON = credential.rawClientDataJSON
		self.rawAttestationObject = credential.rawAttestationObject
	}

	init(from credential: ASAuthorizationPlatformPublicKeyCredentialAssertion) {
		self.credentialID = credential.credentialID
		self.rawClientDataJSON = credential.rawClientDataJSON
		self.rawAuthenticatorData = credential.rawAuthenticatorData
		self.signature = credential.signature
		self.userID = credential.userID
	}
}

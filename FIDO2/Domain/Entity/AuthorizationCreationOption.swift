//
// FIDO2 Example
//
// Copyright © 2025 Nevis Security AG. All rights reserved.
//

import Foundation

struct AuthorizationCreationOption {
	let rpId: String

	var username: String?
	var challenge: Data?
	var userId: Data?
	var attestationPreference: Fido2AttestationConveyancePreference?
	var authenticatorAttachment: Fido2AuthenticatorAttachment?
	var userVerificationPreference: Fido2RequirementOption?
	var residentKeyPreference: Fido2RequirementOption?
	var allowCredentials: [Data]?
	var excludeCredentials: [Data]?
	var pubKeyCredParams: [Int]?
}

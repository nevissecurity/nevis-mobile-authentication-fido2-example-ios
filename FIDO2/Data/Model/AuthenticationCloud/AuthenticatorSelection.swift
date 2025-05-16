//
// FIDO2 Example
//
// Copyright © 2025 Nevis Security AG. All rights reserved.
//

struct AuthenticatorSelection: Codable {
	var authenticatorAttachment: AuthenticatorAttachment?
	var requireResidentKey: Bool?
	var userVerification: UserVerification?
	var residentKey: ResidentKey?
}

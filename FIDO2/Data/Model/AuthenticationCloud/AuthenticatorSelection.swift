//
// FIDO2 Example
//
// Copyright © 2026 Nevis Security AG. All rights reserved.
//

/// DTO for the WebAuthn `AuthenticatorSelectionCriteria` embedded in `CredentialCreationOptions`.
struct AuthenticatorSelection: Codable {
	var authenticatorAttachment: AuthenticatorAttachment?
	var requireResidentKey: Bool?
	var userVerification: UserVerification?
	var residentKey: ResidentKey?
}

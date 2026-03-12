//
// FIDO2 Example
//
// Copyright © 2026 Nevis Security AG. All rights reserved.
//

/// DTO for the WebAuthn `AuthenticatorSelectionCriteria` embedded in `CredentialCreationOptions`.
struct AuthenticatorSelection: Codable {
	/// The authenticator attachment constraint, or `nil` for no preference.
	var authenticatorAttachment: AuthenticatorAttachment?
	/// Legacy boolean form of the resident-key requirement (WebAuthn Level 1). Superseded by ``residentKey``.
	var requireResidentKey: Bool?
	/// The user verification requirement for the ceremony, or `nil` for no preference.
	var userVerification: UserVerification?
	/// The resident-key (discoverable credential) requirement (WebAuthn Level 2+), or `nil` for no preference.
	var residentKey: ResidentKey?
}

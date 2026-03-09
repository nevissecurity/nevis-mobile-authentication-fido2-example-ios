//
// FIDO2 Example
//
// Copyright © 2026 Nevis Security AG. All rights reserved.
//

/// DTO representing the WebAuthn `PublicKeyCredentialCreationOptions` returned by the server
/// during the registration ceremony (from `/api/v1/users/enroll`).
struct CredentialCreationOptions: Codable {
	let user: User
	let challenge: String
	let pubKeyCredParams: [PubKeyCredParam]
	let timeout: Int
	let authenticatorSelection: AuthenticatorSelection
	let attestation: String
	let excludeCredentials: [Credential]
	let rp: RelyingParty
}

// MARK: - Mapping

extension CredentialCreationOptions {
	// MARK: To Domain

	func map() -> Fido2AttestationConveyancePreference? {
		.init(rawValue: attestation)
	}
}

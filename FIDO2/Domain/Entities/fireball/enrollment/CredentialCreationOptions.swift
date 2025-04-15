//
// FIDO2 PoC
//
// Copyright © 2025 NEVIS. All rights reserved.
//

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

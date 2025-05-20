//
// FIDO2 Example
//
// Copyright © 2025 Nevis Security AG. All rights reserved.
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

// MARK: - Mapping

extension CredentialCreationOptions {
	// MARK: To Domain

	func map() -> Fido2AttestationConveyancePreference? {
		.init(rawValue: attestation)
	}
}

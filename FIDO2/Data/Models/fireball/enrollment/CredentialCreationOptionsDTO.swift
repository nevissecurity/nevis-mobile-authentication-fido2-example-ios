//
// FIDO2 PoC
//
// Copyright © 2025 NEVIS. All rights reserved.
//

struct CredentialCreationOptionsDTO: Codable {
	let user: UserDTO
	let challenge: String
	let pubKeyCredParams: [PubKeyCredParamDTO]
	let timeout: Int
	let authenticatorSelection: AuthenticatorSelectionDTO
	let attestation: String
	let excludeCredentials: [CredentialDTO]
	let rp: RelyingPartyDTO
}

extension CredentialCreationOptionsDTO {
	func toDomain() -> CredentialCreationOptions {
		CredentialCreationOptions(
			user: user.toDomain(),
			challenge: challenge,
			pubKeyCredParams: pubKeyCredParams.map { $0.toDomain() },
			timeout: timeout,
			authenticatorSelection: authenticatorSelection.toDomain(),
			attestation: attestation,
			excludeCredentials: excludeCredentials.map { $0.toDomain() },
			rp: rp.toDomain()
		)
	}
}

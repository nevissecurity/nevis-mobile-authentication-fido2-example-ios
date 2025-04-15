//
// FIDO2 PoC
//
// Copyright © 2025 NEVIS. All rights reserved.
//

struct CredentialDTO: Codable {
	let type: String
	let id: String
}

extension CredentialDTO {
	func toDomain() -> Credential {
		Credential(
			type: type,
			id: id
		)
	}
}

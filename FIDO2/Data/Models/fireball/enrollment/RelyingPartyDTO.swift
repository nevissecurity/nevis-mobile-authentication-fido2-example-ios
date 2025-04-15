//
// FIDO2 PoC
//
// Copyright © 2025 NEVIS. All rights reserved.
//

struct RelyingPartyDTO: Codable {
	let id: String
	let name: String
}

extension RelyingPartyDTO {
	func toDomain() -> RelyingParty {
		RelyingParty(id: id, name: name)
	}
}

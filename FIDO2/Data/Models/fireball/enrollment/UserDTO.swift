//
// FIDO2 PoC
//
// Copyright © 2025 NEVIS. All rights reserved.
//

struct UserDTO: Codable {
	let displayName: String
	let id: String
	let name: String
}

extension UserDTO {
	func toDomain() -> User {
		User(
			displayName: displayName,
			id: id,
			name: name
		)
	}
}

//
// FIDO2 PoC
//
// Copyright © 2025 NEVIS. All rights reserved.
//

struct StartEnrollRequest: Encodable {
	let username: String
	let channel: String? = "fido2"
	let displayName: String?
}

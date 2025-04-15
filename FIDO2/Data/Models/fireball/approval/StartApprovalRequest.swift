//
// FIDO2 PoC
//
// Copyright © 2025 NEVIS. All rights reserved.
//

struct StartApprovalRequest: Encodable {
	let channel: String = "fido2"
	let fido2Options: Fido2OptionsDTO
	let username: String?
	let userId: String?
}

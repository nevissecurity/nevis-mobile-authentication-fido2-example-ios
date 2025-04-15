//
// FIDO2 PoC
//
// Copyright © 2025 NEVIS. All rights reserved.
//

struct ApprovalDataDTO: Encodable {
	let authenticatorData: String
	let clientDataJSON: String
	let signature: String
	let userHandle: String
}

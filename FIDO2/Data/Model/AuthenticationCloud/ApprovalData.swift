//
// FIDO2 Example
//
// Copyright © 2025 Nevis Security AG. All rights reserved.
//

struct ApprovalData: Codable {
	let authenticatorData: String
	let clientDataJSON: String
	let signature: String
	let userHandle: String
}

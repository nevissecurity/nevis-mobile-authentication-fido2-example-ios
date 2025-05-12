//
// FIDO2 Example App
//
// Copyright © 2025 Nevis Security AG. All rights reserved.
//

struct ApprovalRequest: Encodable {
	var username: String?
	var userId: String?
	var channel: String = "fido2"
	let fido2Options: ApprovalFido2Options?
}

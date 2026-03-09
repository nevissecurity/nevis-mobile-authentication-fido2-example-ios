//
// FIDO2 Example
//
// Copyright © 2026 Nevis Security AG. All rights reserved.
//

/// DTO for the `POST /api/v1/approval` request that initiates a passkey authentication ceremony.
struct ApprovalRequest: Encodable {
	var username: String?
	var userId: String?
	var channel: String = "fido2"
	let fido2Options: ApprovalFido2Options?
}

//
// FIDO2 Example
//
// Copyright © 2026 Nevis Security AG. All rights reserved.
//

/// DTO for the `POST /api/v1/approval` request that initiates a passkey authentication ceremony.
struct ApprovalRequest: Encodable {
	/// The username of the account to authenticate. `nil` triggers a usernameless/discoverable flow.
	var username: String?
	/// The user identifier. `nil` when not known at request time.
	var userId: String?
	/// The transport channel. Always `"fido2"` for this application.
	var channel: String = "fido2"
	/// Optional FIDO2 policy overrides (e.g. user verification requirement).
	let fido2Options: ApprovalFido2Options?
}

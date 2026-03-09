//
// FIDO2 Example
//
// Copyright © 2026 Nevis Security AG. All rights reserved.
//

/// DTO carrying the authenticator response data for assertion (authentication completion).
///
/// All fields are Base64URL-encoded binary values.
struct ApprovalData: Codable {
	let authenticatorData: String
	let clientDataJSON: String
	let signature: String
	let userHandle: String
}

//
// FIDO2 Example
//
// Copyright © 2026 Nevis Security AG. All rights reserved.
//

/// DTO for the `POST /_app/assertion/result` request that completes passkey authentication.
///
/// All binary fields in `response` are Base64URL-encoded.
struct AssertionRequest: Encodable {
	let type: String
	let id: String
	let response: ApprovalData
	let statusToken: String
	let userAgent: String
}

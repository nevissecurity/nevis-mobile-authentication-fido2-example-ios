//
// FIDO2 Example
//
// Copyright © 2026 Nevis Security AG. All rights reserved.
//

/// DTO for the `POST /_app/assertion/result` request that completes passkey authentication.
///
/// All binary fields in `response` are Base64URL-encoded.
struct AssertionRequest: Encodable {
	/// The credential type. Always `"public-key"` per the WebAuthn spec.
	let type: String
	/// The Base64URL-encoded credential identifier returned by the authenticator.
	let id: String
	/// The authenticator assertion response containing the signed challenge and metadata.
	let response: ApprovalData
	/// The opaque status token obtained from the preceding ``Fido2Repository/startApproval(username:fido2Options:)`` call.
	let statusToken: String
	/// The `User-Agent` header value identifying this client to the server.
	let userAgent: String
}

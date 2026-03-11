//
// FIDO2 Example
//
// Copyright © 2026 Nevis Security AG. All rights reserved.
//

/// DTO carrying the authenticator response data for assertion (authentication completion).
///
/// All fields are Base64URL-encoded binary values.
struct ApprovalData: Codable {
	/// The Base64URL-encoded authenticator data.
	let authenticatorData: String
	/// The Base64URL-encoded client data JSON.
	let clientDataJSON: String
	/// The Base64URL-encoded signature produced by the authenticator.
	let signature: String
	/// The Base64URL-encoded user handle identifying the credential owner.
	let userHandle: String
}

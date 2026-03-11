//
// FIDO2 Example
//
// Copyright © 2026 Nevis Security AG. All rights reserved.
//

/// DTO representing the server's enrollment session, containing the status token
/// and the credential creation options needed to create a passkey.
struct Enrollment: Codable {
	/// The opaque token used to complete the registration ceremony.
	let statusToken: String
	/// The server-side transaction identifier for the enrollment session.
	let transactionId: String
	/// The WebAuthn credential creation options required to drive the passkey creation.
	let credentialCreationOptions: CredentialCreationOptions
}

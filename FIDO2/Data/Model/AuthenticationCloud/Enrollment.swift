//
// FIDO2 Example
//
// Copyright © 2026 Nevis Security AG. All rights reserved.
//

/// DTO representing the server's enrollment session, containing the status token
/// and the credential creation options needed to create a passkey.
struct Enrollment: Codable {
	let statusToken: String
	let transactionId: String
	let credentialCreationOptions: CredentialCreationOptions
}

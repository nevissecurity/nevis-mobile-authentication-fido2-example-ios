//
// FIDO2 Example App
//
// Copyright © 2025 Nevis Security AG. All rights reserved.
//

struct Enrollment: Codable {
	let statusToken: String
	let transactionId: String
	let credentialCreationOptions: CredentialCreationOptions
}

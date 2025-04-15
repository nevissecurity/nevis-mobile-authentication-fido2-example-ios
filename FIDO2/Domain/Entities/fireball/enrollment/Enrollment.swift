//
// FIDO2 PoC
//
// Copyright © 2025 NEVIS. All rights reserved.
//

struct Enrollment: Codable {
	let statusToken: String
	let transactionId: String
	let credentialCreationOptions: CredentialCreationOptions
}

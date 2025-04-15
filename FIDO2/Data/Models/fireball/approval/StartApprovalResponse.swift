//
// FIDO2 PoC
//
// Copyright © 2025 NEVIS. All rights reserved.
//

struct StartApprovalResponse: Decodable {
	let credentialRequestOptions: CredentialRequestOptionsDTO
	let userId: String
	let statusToken: String
	let transactionId: String
}

//
// FIDO2 Example
//
// Copyright © 2025 Nevis Security AG. All rights reserved.
//

struct AssertionRequest: Encodable {
	let type: String
	let id: String
	let response: ApprovalData
	let statusToken: String
	let userAgent: String
}

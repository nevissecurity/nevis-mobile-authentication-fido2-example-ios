//
// FIDO2 PoC
//
// Copyright © 2025 NEVIS. All rights reserved.
//

import Foundation

struct CompleteApprovalRequest: Encodable {
	let id: String
	let response: ApprovalDataDTO
	let statusToken: String
	let type: String
	let userAgent: String
}

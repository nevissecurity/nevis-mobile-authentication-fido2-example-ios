//
// FIDO2 PoC
//
// Copyright © 2025 NEVIS. All rights reserved.
//

import Foundation

struct CompleteEnrollRequest: Codable {
	let id: String
	let type: String
	let response: EnrollmentDataDTO
	let statusToken: String
	let userFriendlyName: String
	let userAgent: String
}

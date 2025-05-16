//
// FIDO2 Example
//
// Copyright © 2025 Nevis Security AG. All rights reserved.
//

struct AttestationRequest: Codable {
	let type: String
	let id: String
	let response: EnrollmentData
	let statusToken: String
	let userFriendlyName: String
	let userAgent: String
}

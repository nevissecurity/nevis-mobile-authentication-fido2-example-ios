//
// FIDO2 PoC
//
// Copyright © 2025 NEVIS. All rights reserved.
//

struct EnrollResponse: Codable {
	let userId: String
	let username: String
	let status: String
	let authenticators: Set<String>
	let enrollment: Enrollment
}

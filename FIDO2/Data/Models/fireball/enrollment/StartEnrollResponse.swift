//
// FIDO2 PoC
//
// Copyright © 2025 NEVIS. All rights reserved.
//

struct StartEnrollResponse: Decodable {
	let userId: String
	let username: String
	let status: String
	let authenticators: Set<String>
	let enrollment: EnrollmentDTO
}

extension StartEnrollResponse {
	func toDomain() -> EnrollResponse {
		EnrollResponse(
			userId: userId,
			username: username,
			status: status,
			authenticators: authenticators,
			enrollment: enrollment.toDomain()
		)
	}
}

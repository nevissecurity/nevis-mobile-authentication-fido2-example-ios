//
// FIDO2 PoC
//
// Copyright © 2025 NEVIS. All rights reserved.
//

struct EnrollmentDTO: Codable {
	let statusToken: String
	let transactionId: String
	let credentialCreationOptions: CredentialCreationOptionsDTO
}

extension EnrollmentDTO {
	func toDomain() -> Enrollment {
		Enrollment(
			statusToken: statusToken,
			transactionId: transactionId,
			credentialCreationOptions: credentialCreationOptions.toDomain()
		)
	}
}

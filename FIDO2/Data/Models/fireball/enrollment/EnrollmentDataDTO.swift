//
// FIDO2 PoC
//
// Copyright © 2025 NEVIS. All rights reserved.
//

struct EnrollmentDataDTO: Codable {
	let attestationObject: String
	let clientDataJSON: String
}

//
// FIDO2 Example App
//
// Copyright © 2025 Nevis Security AG. All rights reserved.
//

struct EnrollmentData: Codable {
	let attestationObject: String
	let clientDataJSON: String
}

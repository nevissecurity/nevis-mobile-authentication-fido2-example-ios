//
// FIDO2 Example
//
// Copyright © 2026 Nevis Security AG. All rights reserved.
//

/// DTO for the `POST /api/v1/users/enroll` request that kicks off the registration ceremony.
struct RegistrationRequest: Encodable {
	let username: String
	var channel: String? = "fido2"
	let displayName: String?
	let fido2Options: RegistrationFido2Options?
}

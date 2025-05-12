//
// FIDO2 Example App
//
// Copyright © 2025 Nevis Security AG. All rights reserved.
//

struct RegistrationRequest: Encodable {
	let username: String
	var channel: String? = "fido2"
	let displayName: String?
	let fido2Options: RegistrationFido2Options?
}

//
// FIDO2 Example
//
// Copyright © 2026 Nevis Security AG. All rights reserved.
//

/// DTO for the `POST /api/v1/users/enroll` request that kicks off the registration ceremony.
struct RegistrationRequest: Encodable {
	/// The username to register.
	let username: String
	/// The transport channel. Always `"fido2"` for this application.
	var channel: String? = "fido2"
	/// A human-readable display name for the user, or `nil` to use the username.
	let displayName: String?
	/// Optional FIDO2 policy overrides for the registration ceremony.
	let fido2Options: RegistrationFido2Options?
}

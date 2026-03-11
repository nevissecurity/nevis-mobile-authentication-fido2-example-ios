//
// FIDO2 Example
//
// Copyright © 2026 Nevis Security AG. All rights reserved.
//

/// DTO carrying the authenticator response for attestation (registration completion).
///
/// Both fields are Base64URL-encoded binary data.
struct EnrollmentData: Codable {
	/// The Base64URL-encoded attestation object produced by the authenticator during registration.
	let attestationObject: String
	/// The Base64URL-encoded client data JSON signed by the authenticator.
	let clientDataJSON: String
}

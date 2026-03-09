//
// FIDO2 Example
//
// Copyright © 2026 Nevis Security AG. All rights reserved.
//

/// DTO carrying the authenticator response for attestation (registration completion).
///
/// Both fields are Base64URL-encoded binary data.
struct EnrollmentData: Codable {
	let attestationObject: String
	let clientDataJSON: String
}

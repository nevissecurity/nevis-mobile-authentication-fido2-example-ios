//
// FIDO2 Example
//
// Copyright © 2026 Nevis Security AG. All rights reserved.
//

/// DTO for the `POST /_app/attestation/result` request that completes passkey registration.
///
/// All binary fields in `response` are Base64URL-encoded to comply with the WebAuthn JSON spec.
struct AttestationRequest: Encodable {
	let type: String
	let id: String
	let response: EnrollmentData
	let statusToken: String
	let userFriendlyName: String
	let userAgent: String
}

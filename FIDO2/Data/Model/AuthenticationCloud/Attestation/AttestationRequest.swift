//
// FIDO2 Example
//
// Copyright © 2026 Nevis Security AG. All rights reserved.
//

/// DTO for the `POST /_app/attestation/result` request that completes passkey registration.
///
/// All binary fields in `response` are Base64URL-encoded to comply with the WebAuthn JSON spec.
struct AttestationRequest: Encodable {
	/// The credential type. Always `"public-key"` per the WebAuthn spec.
	let type: String
	/// The Base64URL-encoded credential identifier returned by the authenticator.
	let id: String
	/// The attestation response data containing the attestation object and client data.
	let response: EnrollmentData
	/// The opaque status token obtained from the preceding registration call.
	let statusToken: String
	/// A human-readable name for the device, shown in credential management UI.
	let userFriendlyName: String
	/// The `User-Agent` header value identifying this client to the server.
	let userAgent: String
}

//
// FIDO2 Example
//
// Copyright © 2026 Nevis Security AG. All rights reserved.
//

/// DTO representing the WebAuthn `PublicKeyCredentialCreationOptions` returned by the server
/// during the registration ceremony (from `/api/v1/users/enroll`).
struct CredentialCreationOptions: Codable {
	/// The user account information for the credential being created.
	let user: User
	/// The Base64URL-encoded challenge bytes that must be included in the attestation.
	let challenge: String
	/// The acceptable public key algorithm identifiers, in order of preference.
	let pubKeyCredParams: [PubKeyCredParam]
	/// The time limit in milliseconds the client is allowed to wait for authenticator interaction.
	let timeout: Int
	/// Criteria for selecting the authenticator type and capabilities.
	let authenticatorSelection: AuthenticatorSelection
	/// The attestation conveyance preference string (e.g. `"none"`, `"indirect"`, `"direct"`).
	let attestation: String
	/// Credential IDs to exclude, preventing re-registration of existing credentials.
	let excludeCredentials: [Credential]
	/// The relying party information (RP ID and name).
	let rp: RelyingParty
}

// MARK: - Mapping

extension CredentialCreationOptions {
	// MARK: To Domain

	/// Maps the `attestation` string field to the domain ``Fido2AttestationConveyancePreference``.
	///
	/// - Returns: The matching preference, or `nil` if the raw value is unrecognised.
	func map() -> Fido2AttestationConveyancePreference? {
		.init(rawValue: attestation)
	}
}

//
// FIDO2 Example
//
// Copyright © 2026 Nevis Security AG. All rights reserved.
//

import Foundation

/// Carries the FIDO2 options and server-provided challenge data needed to create an
/// `ASAuthorizationRequest`.
///
/// Populated by mapping from the server's `CredentialCreationOptions` (registration)
/// or `CredentialRequestOptions` (authentication).
struct AuthorizationCreationOption {
	/// The relying party identifier (RP ID), typically the app's associated domain hostname.
	let rpId: String

	/// The username associated with the credential, if known.
	var username: String?
	/// The server-generated challenge bytes that must be signed by the authenticator.
	var challenge: Data?
	/// The user handle bytes used to identify the user account for the credential.
	var userId: Data?
	/// The requested attestation conveyance preference, if set.
	var attestationPreference: Fido2AttestationConveyancePreference?
	/// Restricts the type of authenticator that may be used, if set.
	var authenticatorAttachment: Fido2AuthenticatorAttachment?
	/// The required level of user verification, if set.
	var userVerificationPreference: Fido2RequirementOption?
	/// The resident key (discoverable credential) preference, if set.
	var residentKeyPreference: Fido2RequirementOption?
	/// Credential IDs the authenticator is allowed to assert (assertion only).
	var allowCredentials: [Data]?
	/// Credential IDs that should be excluded from registration (registration only).
	var excludeCredentials: [Data]?
	/// Acceptable public key algorithm identifiers (COSE algorithm numbers).
	var pubKeyCredParams: [Int]?
}

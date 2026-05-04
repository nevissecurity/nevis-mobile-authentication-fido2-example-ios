//
// FIDO2 Example
//
// Copyright © 2026 Nevis Security AG. All rights reserved.
//

/// A value type that bundles the user-selectable FIDO2 policy options.
///
/// `nil` values indicate "use server default" for the corresponding option.
struct Fido2Options {
	/// The user verification requirement. `nil` means use the server's default.
	var userVerificationRequirement: Fido2RequirementOption?
	/// The authenticator attachment constraint. `nil` means no constraint.
	var authenticatorAttachment: Fido2AuthenticatorAttachment?
	/// The attestation conveyance preference. `nil` means use the server's default.
	var attestationConveyancePreference: Fido2AttestationConveyancePreference?
	/// The resident key (discoverable credential) requirement. `nil` means use the server's default.
	var residentKeyRequirement: Fido2RequirementOption?
}

/// Expresses whether an operation (user verification or resident key) is required, preferred, or discouraged.
enum Fido2RequirementOption: String, Equatable {
	/// The operation is mandatory.
	case required
	/// The operation is preferred but not mandatory.
	case preferred
	/// The operation should not be performed.
	case discouraged
}

/// Restricts which class of authenticator may fulfill a FIDO2 request.
enum Fido2AuthenticatorAttachment: String, Equatable {
	/// A built-in platform authenticator (Face ID, Touch ID).
	case platform
	/// A roaming cross-platform authenticator (security key, another device).
	case crossPlatform = "cross-platform"
}

/// Controls what attestation statement the server requests from the authenticator.
enum Fido2AttestationConveyancePreference: String, Equatable {
	/// No attestation statement is required.
	case none
	/// An anonymised attestation statement is requested.
	case indirect
	/// A full attestation statement is requested.
	case direct
}

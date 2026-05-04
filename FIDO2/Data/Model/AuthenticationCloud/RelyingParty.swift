//
// FIDO2 Example
//
// Copyright © 2026 Nevis Security AG. All rights reserved.
//

/// DTO representing the relying party (RP) information in a WebAuthn ceremony.
struct RelyingParty: Codable {
	/// The RP identifier, typically the app's associated domain hostname (e.g. `"myinstance.mauth.nevis.cloud"`).
	let id: String
	/// A human-readable name for the relying party, displayed by the authenticator UI.
	let name: String
}

//
// FIDO2 Example
//
// Copyright © 2026. Nevis Security AG. All rights reserved.
//

import Foundation

/// A subset of JWT claims returned by the token introspection endpoint.
struct IntrospectInfo {
	/// Whether the token is currently active (not expired, not revoked).
	let isActive: Bool
	/// The time the token was issued, expressed as milliseconds since Unix epoch.
	let issuedAt: Int64?
	/// The subject claim — typically the user's identifier on the Authentication Cloud.
	let subject: String?
}

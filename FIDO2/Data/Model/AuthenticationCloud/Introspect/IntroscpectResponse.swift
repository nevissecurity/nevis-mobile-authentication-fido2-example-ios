//
// FIDO2 Example
//
// Copyright © 2026. Nevis Security AG. All rights reserved.
//

import Foundation

/// DTO for the `POST /api/v1/introspect` response, containing standard JWT introspection claims
/// as defined in RFC 7662.
///
/// Note: the filename contains a known typo (`IntroscpectResponse`) — do not rename.
struct IntrospectResponse: Decodable {
	/// Whether the token is currently active (not expired, not revoked).
	let active: Bool?
	/// The time the token was issued, as Unix epoch seconds.
	let iat: Int64?
	/// The earliest time the token may be used, as Unix epoch seconds.
	let nbf: Int64?
	/// The subject of the token, typically the user identifier.
	let sub: String?
	/// The intended audience of the token.
	let aud: String?
	/// The issuer of the token.
	let iss: URL?
	/// A unique identifier for the token (JWT ID).
	let jti: String?
	/// The scope of access granted by the token.
	let scope: String?
}

// MARK: - Map to domain

extension IntrospectResponse {
	/// Maps this response to a domain ``IntrospectInfo``.
	///
	/// - Returns: An ``IntrospectInfo`` with the active flag, issued-at timestamp, and subject claim extracted from the JWT.
	func map() -> IntrospectInfo {
		.init(
			isActive: active ?? false,
			issuedAt: iat,
			subject: sub,
		)
	}
}

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
	let active: Bool?
	let iat: Int64?
	let nbf: Int64?
	let sub: String?
	let aud: String?
	let iss: URL?
	let jti: String?
	let scope: String?
}

// MARK: - Map to domain

extension IntrospectResponse {
	func map() -> IntrospectInfo {
		.init(
			isActive: active ?? false,
			issuedAt: iat,
			subject: sub,
		)
	}
}

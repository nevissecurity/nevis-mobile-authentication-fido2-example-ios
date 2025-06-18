//
// FIDO2 Example
//
// Copyright © 2025. Nevis Security AG. All rights reserved.
//

import Foundation

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

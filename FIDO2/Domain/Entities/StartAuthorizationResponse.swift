//
// FIDO2 Example App
//
// Copyright © 2025 Nevis Security AG. All rights reserved.
//

import AuthenticationServices

struct StartAuthorizationResponse {
	let asAuthorizationRequest: ASAuthorizationRequest
	let statusToken: String
	var username: String?
}

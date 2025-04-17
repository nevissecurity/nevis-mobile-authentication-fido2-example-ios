//
// FIDO2 Example
//
// Copyright © 2025 Nevis Security AG. All rights reserved.
//

import AuthenticationServices

final class AuthorizationController: ASAuthorizationController {
	let startAuthorizationResponse: StartAuthorizationResponse
	let isAutoFillAssisted: Bool

	init(startAuthorizationResponse: StartAuthorizationResponse, isAutoFillAssisted: Bool) {
		self.startAuthorizationResponse = startAuthorizationResponse
		self.isAutoFillAssisted = isAutoFillAssisted
		super.init(authorizationRequests: [startAuthorizationResponse.asAuthorizationRequest])
	}
}

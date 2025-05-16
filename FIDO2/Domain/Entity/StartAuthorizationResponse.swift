//
// FIDO2 Example
//
// Copyright © 2025 Nevis Security AG. All rights reserved.
//

// MARK: - StartAuthorizationResponse

enum StartAuthorizationResponse {
	case credentialRegistration(username: String, statusToken: String, authorizationCreationOption: AuthorizationCreationOption)
	case credentialAssertion(username: String? = nil, statusToken: String, authorizationCreationOption: AuthorizationCreationOption)
}

extension StartAuthorizationResponse {
	var userName: String? {
		switch self {
		case let .credentialRegistration(username, _, _):
			username
		case let .credentialAssertion(username, _, _):
			username
		}
	}

	var statusToken: String {
		switch self {
		case let .credentialRegistration(_, statusToken, _):
			statusToken
		case let .credentialAssertion(_, statusToken, _):
			statusToken
		}
	}
}

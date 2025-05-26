//
// FIDO2 Example
//
// Copyright © 2025 Nevis Security AG. All rights reserved.
//

// MARK: - StartAuthorizationResponse

enum StartAuthorizationResponse {
	case credentialRegistration(username: String, statusToken: String, authorizationCreationOption: AuthorizationCreationOption)
	case credentialAssertion(statusToken: String, authorizationCreationOption: AuthorizationCreationOption)
	case webAuthorization
}

extension StartAuthorizationResponse {
	var userName: String? {
		switch self {
		case let .credentialRegistration(username, _, _):
			username
		default:
			nil
		}
	}

	var statusToken: String {
		switch self {
		case let .credentialRegistration(_, statusToken, _):
			statusToken
		case let .credentialAssertion(statusToken, _):
			statusToken
		default:
			fatalError("Invalid state")
		}
	}
}

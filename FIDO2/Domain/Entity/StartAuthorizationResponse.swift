//
// FIDO2 Example
//
// Copyright © 2026 Nevis Security AG. All rights reserved.
//

// MARK: - StartAuthorizationResponse

/// The response from ``StartAuthorizationUseCase``, representing the next step in the
/// authorization flow.
enum StartAuthorizationResponse {
	/// The server has responded with credential creation options; the passkey registration sheet should be presented.
	///
	/// - Parameters:
	///   - username: The username being registered.
	///   - statusToken: The session token to pass to the completion step.
	///   - authorizationCreationOption: The server-provided options for `ASAuthorizationController`.
	case credentialRegistration(username: String, statusToken: String, authorizationCreationOption: AuthorizationCreationOption)

	/// The server has responded with credential request options; the passkey assertion sheet should be presented.
	///
	/// - Parameters:
	///   - statusToken: The session token to pass to the completion step.
	///   - authorizationCreationOption: The server-provided options for `ASAuthorizationController`.
	case credentialAssertion(statusToken: String, authorizationCreationOption: AuthorizationCreationOption)

	/// The web-based authorization session has been initiated; no further immediate action is required.
	case webAuthorization
}

extension StartAuthorizationResponse {
	/// The username associated with a registration response, or `nil` for other response types.
	var userName: String? {
		switch self {
			case let .credentialRegistration(username, _, _):
				username
			default:
				nil
		}
	}

	/// The session token from the server, used as input to the completion step.
	///
	/// Accessing this on a `.webAuthorization` response is a programming error and triggers a `fatalError`.
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

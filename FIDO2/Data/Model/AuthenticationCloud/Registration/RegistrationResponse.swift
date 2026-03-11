//
// FIDO2 Example
//
// Copyright © 2026 Nevis Security AG. All rights reserved.
//

/// DTO for the `POST /api/v1/users/enroll` response that includes the enrollment session
/// and the WebAuthn credential creation options.
struct RegistrationResponse: ServerResponse {
	var errorMessage: String?
	var status: String?

	/// The server-generated unique identifier for the registered user.
	let userId: String
	/// The username that was registered.
	let username: String
	/// The set of authenticator identifiers already registered for this user.
	let authenticators: Set<String>
	/// The enrollment session containing the status token and credential creation options.
	let enrollment: Enrollment
}

// MARK: - Mapping

extension RegistrationResponse {
	// MARK: To Domain

	/// Maps this response to a domain ``StartAuthorizationResponse``.
	///
	/// - Parameter username: The username being registered.
	/// - Returns: `.success` with a `.credentialRegistration` response, or `.failure` wrapping an ``AppError`` if the server returned an error.
	func map(username: String) -> Result<StartAuthorizationResponse, AppError> {
		if isError {
			return .failure(AppError.request(message: errorMessage))
		}

		let credentialCreationOptions = enrollment.credentialCreationOptions
		let authorizationCreationOptions = AuthorizationCreationOption(
			rpId: credentialCreationOptions.rp.id,
			username: username,
			challenge: credentialCreationOptions.challenge.base64UrlDecodedData,
			userId: credentialCreationOptions.user.id.base64UrlDecodedData,
			attestationPreference: credentialCreationOptions.map(),
			authenticatorAttachment: credentialCreationOptions.authenticatorSelection.authenticatorAttachment?.map(),
			userVerificationPreference: credentialCreationOptions.authenticatorSelection.userVerification?.map(),
			residentKeyPreference: credentialCreationOptions.authenticatorSelection.residentKey?.map(),
			excludeCredentials: credentialCreationOptions.excludeCredentials.compactMap(\.id.base64UrlDecodedData),
			pubKeyCredParams: credentialCreationOptions.pubKeyCredParams.map(\.alg),
		)

		return .success(.credentialRegistration(username: username, statusToken: enrollment.statusToken, authorizationCreationOption: authorizationCreationOptions))
	}
}

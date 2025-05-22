//
// FIDO2 Example
//
// Copyright © 2025 Nevis Security AG. All rights reserved.
//

struct RegistrationResponse: ServerResponse {
	var errorMessage: String?
	var status: String?

	let userId: String
	let username: String
	let authenticators: Set<String>
	let enrollment: Enrollment
}

// MARK: - Mapping

extension RegistrationResponse {
	// MARK: To Domain

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

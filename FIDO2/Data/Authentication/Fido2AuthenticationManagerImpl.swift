//
// FIDO2 PoC
//
// Copyright © 2025 NEVIS. All rights reserved.
//

import AuthenticationServices
import Combine
import UIKit

final class Fido2AuthenticationManagerImpl: NSObject, Fido2AuthenticationManager {
	private var delegateStorage = [Fido2AuthorizationDelegate]()

	func enroll(username: String, credentialCreationOptions: CredentialCreationOptions) -> AnyPublisher<ASAuthorization, Error> {
		Deferred {
			Future { promise in
				let provider = ASAuthorizationPlatformPublicKeyCredentialProvider(relyingPartyIdentifier: credentialCreationOptions.rp.id)
				let registrationRequest = provider.createCredentialRegistrationRequest(
					// TODO error handling
					challenge: credentialCreationOptions.challenge.base64UrlDecodedData!,
					name: username,
					userID: credentialCreationOptions.user.id.base64UrlDecodedData!,
				)
				registrationRequest.attestationPreference = ASAuthorizationPublicKeyCredentialAttestationKind.init(rawValue: credentialCreationOptions.attestation)
				registrationRequest.userVerificationPreference = ASAuthorizationPublicKeyCredentialUserVerificationPreference.init(rawValue: credentialCreationOptions.authenticatorSelection.userVerification.rawValue)

				let controller = ASAuthorizationController(authorizationRequests: [registrationRequest])
				var weakDelegate: Fido2AuthorizationDelegate?
				let delegate = Fido2AuthorizationDelegate { [weak self] result in
					guard let self = self, let delegate = weakDelegate else { return }
					promise(result)

					if let index = self.delegateStorage.firstIndex(where: { $0 === delegate }) {
						self.delegateStorage.remove(at: index)
					}
				}
				weakDelegate = delegate
				self.delegateStorage.append(delegate)
				controller.delegate = delegate
				controller.presentationContextProvider = delegate
				controller.performRequests()
			}
		}
		.eraseToAnyPublisher()
	}

	func authenticate(credentialRequestOptions: CredentialRequestOptionsDTO) -> AnyPublisher<ASAuthorization, Error> {
		Deferred {
			Future { promise in
				let provider = ASAuthorizationPlatformPublicKeyCredentialProvider(relyingPartyIdentifier: credentialRequestOptions.rpId)
				let authRequest = provider.createCredentialAssertionRequest(challenge: credentialRequestOptions.challenge.base64UrlDecodedData!)
				authRequest.userVerificationPreference = ASAuthorizationPublicKeyCredentialUserVerificationPreference.init(rawValue: credentialRequestOptions.userVerification.rawValue)
				authRequest.allowedCredentials = credentialRequestOptions.allowCredentials.map { element in .init(credentialID: element.id.base64UrlDecodedData!) }

				let controller = ASAuthorizationController(authorizationRequests: [authRequest])
				var weakDelegate: Fido2AuthorizationDelegate?
				let delegate = Fido2AuthorizationDelegate { [weak self] result in
					guard let self = self, let delegate = weakDelegate else { return }
					promise(result)

					if let index = self.delegateStorage.firstIndex(where: { $0 === delegate }) {
						self.delegateStorage.remove(at: index)
					}
				}
				weakDelegate = delegate
				self.delegateStorage.append(delegate)
				controller.delegate = delegate
				controller.presentationContextProvider = delegate
				controller.performRequests()
			}
		}
		.eraseToAnyPublisher()
	}
}

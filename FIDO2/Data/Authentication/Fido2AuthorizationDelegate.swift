//
// FIDO2 PoC
//
// Copyright © 2025 NEVIS. All rights reserved.
//

import Foundation
import AuthenticationServices

final class Fido2AuthorizationDelegate: NSObject, ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
	
	private let completion: (Result<ASAuthorization, Error>) -> Void

	init(completion: @escaping (Result<ASAuthorization, Error>) -> Void) {
		self.completion = completion
	}
	
	func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
		print("FIDO 2 authorization completed")
		completion(.success(authorization))
	}
	
	func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
		print("FIDO 2 authorization failed")
		completion(.failure(error))
	}
	
	func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
		guard let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
			  let window = scene.windows.first else {
			fatalError("No available window")
		}
		return window
	}
}

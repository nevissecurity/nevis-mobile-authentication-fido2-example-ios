//
// FIDO2 Example
//
// Copyright © 2025 Nevis Security AG. All rights reserved.
//

import AuthenticationServices
import Combine

final class AuthorizationServiceImpl: NSObject {
	private var currentAuthorizationController: AuthorizationController?
	private var resultPublisher = PassthroughSubject<Result<CompleteAuthorizationRequest, AuthorizationServiceError>, Never>()
}

// MARK: - AuthorizationService

extension AuthorizationServiceImpl: AuthorizationService {
	var onComplete: AnyPublisher<Result<CompleteAuthorizationRequest, AuthorizationServiceError>, Never> {
		resultPublisher.eraseToAnyPublisher()
	}

	func start(_ startAuthorizationResponse: StartAuthorizationResponse, isAutoFillAssisted: Bool = false) {
		if currentAuthorizationController != nil {
			cancel()
		}

		currentAuthorizationController = AuthorizationController(startAuthorizationResponse: startAuthorizationResponse, isAutoFillAssisted: isAutoFillAssisted)
		currentAuthorizationController?.delegate = self
		if isAutoFillAssisted {
			currentAuthorizationController?.performAutoFillAssistedRequests()
		}
		else {
			currentAuthorizationController?.presentationContextProvider = self
			currentAuthorizationController?.performRequests()
		}
	}

	func cancel() {
		currentAuthorizationController?.cancel()
	}
}

// MARK: - ASAuthorizationControllerPresentationContextProviding

extension AuthorizationServiceImpl: ASAuthorizationControllerPresentationContextProviding {
	func presentationAnchor(for _: ASAuthorizationController) -> ASPresentationAnchor {
		UIApplication.shared.connectedScenes
			.compactMap { $0 as? UIWindowScene }
			.first?.windows
			.first { $0.isKeyWindow } ?? UIWindow()
	}
}

// MARK: - ASAuthorizationControllerDelegate

extension AuthorizationServiceImpl: ASAuthorizationControllerDelegate {
	func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
		guard let authorizationController = controller as? AuthorizationController else { return }

		let completeAuhorizationRequest: CompleteAuthorizationRequest? = switch authorization.credential {
		case let asResult as ASAuthorizationPlatformPublicKeyCredentialRegistration where authorizationController.startAuthorizationResponse.username != nil:
			.credentialRegistration(username: authorizationController.startAuthorizationResponse.username!, statusToken: authorizationController.startAuthorizationResponse.statusToken, asResult: asResult)
		case let asResult as ASAuthorizationPlatformPublicKeyCredentialAssertion:
			.credentialAssertion(statusToken: authorizationController.startAuthorizationResponse.statusToken, asResult: asResult)
		default:
			nil
		}

		guard let completeAuhorizationRequest else { return }
		resultPublisher.send(.success(completeAuhorizationRequest))
	}

	func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: any Error) {
		guard let authorizationController = controller as? AuthorizationController else { return }

		if (error as? ASAuthorizationError)?.code == .canceled {
			return resultPublisher.send(.failure(.canceled(isPrefillAssisted: authorizationController.isAutoFillAssisted)))
		}
		resultPublisher.send(.failure(.failed(isPrefillAssisted: authorizationController.isAutoFillAssisted, underlyingError: error)))
	}
}

// MARK: - Preview

extension AuthorizationServiceImpl {
	static var preview: some AuthorizationService {
		AuthorizationServiceImpl()
	}
}

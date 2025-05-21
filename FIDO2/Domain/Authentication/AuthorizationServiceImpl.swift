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

		do {
			currentAuthorizationController = try AuthorizationController(startAuthorizationResponse: startAuthorizationResponse, isAutoFillAssisted: isAutoFillAssisted)
			currentAuthorizationController?.delegate = self
			if isAutoFillAssisted {
				currentAuthorizationController?.performAutoFillAssistedRequests()
			}
			else {
				currentAuthorizationController?.presentationContextProvider = self
				currentAuthorizationController?.performRequests()
			}
		}
		catch {
			resultPublisher.send(.failure(.failed(isPrefillAssisted: isAutoFillAssisted, underlyingError: error)))
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

		let completeAuthorizationRequest: CompleteAuthorizationRequest? = switch authorization.credential {
		case let asResult as ASAuthorizationPlatformPublicKeyCredentialRegistration:
			.credentialRegistration(deviceName: UIDevice.deviceName, statusToken: authorizationController.startAuthorizationResponse.statusToken, authorizationResult: AuthorizationResult(from: asResult))
		case let asResult as ASAuthorizationPlatformPublicKeyCredentialAssertion:
			.credentialAssertion(statusToken: authorizationController.startAuthorizationResponse.statusToken, authorizationResult: AuthorizationResult(from: asResult))
		default:
			nil
		}

		guard let completeAuthorizationRequest else { return }
		resultPublisher.send(.success(completeAuthorizationRequest))
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

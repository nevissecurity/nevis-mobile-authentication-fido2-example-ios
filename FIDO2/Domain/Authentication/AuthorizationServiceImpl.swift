//
// FIDO2 Example
//
// Copyright © 2026 Nevis Security AG. All rights reserved.
//

import AuthenticationServices
import Combine

/// Concrete implementation of ``AuthorizationService``.
///
/// Maintains at most one active `ASAuthorizationController` and one active
/// `ASWebAuthenticationSession` at a time. Results are forwarded via a
/// `PassthroughSubject` to all subscribers of ``onComplete``.
final class AuthorizationServiceImpl: NSObject {
	/// The currently active passkey authorization controller, or `nil` when idle.
	private var currentAuthorizationController: AuthorizationController?
	/// The currently active web authentication session, or `nil` when idle.
	private var currentWebAuthenticationSession: ASWebAuthenticationSession?
	/// Forwards each authorization result to all ``onComplete`` subscribers.
	private var resultPublisher = PassthroughSubject<Result<CompleteAuthorizationRequest, AuthorizationServiceError>, Never>()
}

// MARK: - AuthorizationService

extension AuthorizationServiceImpl: AuthorizationService {
	/// A publisher that emits the result of each authorization attempt.
	var onComplete: AnyPublisher<Result<CompleteAuthorizationRequest, AuthorizationServiceError>, Never> {
		resultPublisher.eraseToAnyPublisher()
	}

	/// Starts a passkey registration or authentication flow.
	///
	/// Cancels any active session before starting a new one. On failure, publishes a
	/// ``AuthorizationServiceError/failed(isPrefillAssisted:errorMessage:underlyingError:)`` result.
	///
	/// - Parameters:
	///   - startAuthorizationResponse: The server options returned by ``StartAuthorizationUseCase``.
	///   - isAutoFillAssisted: Pass `true` to use QuickType bar auto-fill instead of the modal sheet.
	func start(_ startAuthorizationResponse: StartAuthorizationResponse, isAutoFillAssisted: Bool = false) {
		if currentAuthorizationController != nil {
			cancel()
		}

		do {
			currentAuthorizationController = try AuthorizationController(startAuthorizationResponse: startAuthorizationResponse, isAutoFillAssisted: isAutoFillAssisted)
			currentAuthorizationController?.delegate = self
			if isAutoFillAssisted {
				currentAuthorizationController?.performAutoFillAssistedRequests()
			} else {
				currentAuthorizationController?.presentationContextProvider = self
				currentAuthorizationController?.performRequests()
			}
		} catch {
			resultPublisher.send(.failure(.failed(isPrefillAssisted: isAutoFillAssisted, underlyingError: error)))
		}
	}

	/// Cancels the currently active `ASAuthorizationController` session, if any.
	func cancel() {
		currentAuthorizationController?.cancel()
	}

	/// Starts a web-based OAuth/OIDC authorization flow using `ASWebAuthenticationSession`.
	///
	/// Cancels any active web session before starting a new one. Publishes success or failure
	/// results via ``onComplete``.
	///
	/// - Parameters:
	///   - url: The authorization URL to open in the system browser.
	///   - callbackUrlScheme: The URL scheme the server will redirect to after authorization.
	func startWeb(url: URL, callbackUrlScheme: String) {
		if currentWebAuthenticationSession != nil {
			cancelWeb()
		}

		currentWebAuthenticationSession = ASWebAuthenticationSession(url: url, callbackURLScheme: callbackUrlScheme) { [weak self] callbackURL, error in
			if let error {
				self?.resultPublisher.send(.failure(.failed(isPrefillAssisted: false, underlyingError: error)))
				return
			}

			guard
				let callbackURL,
				let queryItems = URLComponents(url: callbackURL, resolvingAgainstBaseURL: false)?.queryItems
			else {
				self?.resultPublisher.send(.failure(.failed(isPrefillAssisted: false, errorMessage: "Invalid callback URL")))
				return
			}

			if callbackURL.host == "success", let authorizationToken = queryItems.first(where: { $0.name == "token" })?.value {
				self?.resultPublisher.send(.success(.completedWebAuthorization(authorizationToken: authorizationToken)))
				return
			}
			self?.resultPublisher.send(.failure(.failed(isPrefillAssisted: false, errorMessage: queryItems.first(where: { $0.name == "error" })?.value ?? "Unknown error")))
		}
		currentWebAuthenticationSession?.presentationContextProvider = self
		currentWebAuthenticationSession?.start()
	}

	/// Cancels the currently active `ASWebAuthenticationSession`, if any.
	func cancelWeb() {
		currentWebAuthenticationSession?.cancel()
	}
}

// MARK: - PresentationContextProviding

extension AuthorizationServiceImpl: ASAuthorizationControllerPresentationContextProviding, ASWebAuthenticationPresentationContextProviding {
	/// The key window used as the presentation anchor for all authorization UI.
	@MainActor
	private var presentationAnchor: ASPresentationAnchor {
		UIApplication.shared.connectedScenes
			.compactMap { $0 as? UIWindowScene }
			.first?.windows
			.first { $0.isKeyWindow } ?? UIWindow()
	}

	/// Returns the presentation anchor for `ASAuthorizationController`.
	///
	/// - Parameter _: The controller requesting the anchor (unused).
	/// - Returns: The app's current key window.
	func presentationAnchor(for _: ASAuthorizationController) -> ASPresentationAnchor {
		presentationAnchor
	}

	/// Returns the presentation anchor for `ASWebAuthenticationSession`.
	///
	/// - Parameter _: The session requesting the anchor (unused).
	/// - Returns: The app's current key window.
	func presentationAnchor(for _: ASWebAuthenticationSession) -> ASPresentationAnchor {
		presentationAnchor
	}
}

// MARK: - ASAuthorizationControllerDelegate

extension AuthorizationServiceImpl: ASAuthorizationControllerDelegate {
	/// Called when `ASAuthorizationController` completes successfully.
	///
	/// Extracts the FIDO2 credential data from the result and publishes a
	/// ``CompleteAuthorizationRequest`` on ``onComplete``.
	///
	/// - Parameters:
	///   - controller: The controller that completed the request.
	///   - authorization: The authorization object containing the credential.
	func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
		guard let authorizationController = controller as? AuthorizationController else { return }

		// Extract FIDO2 data from the credential type returned by ASAuthorizationController:
		// • Registration → credentialID + rawClientDataJSON + rawAttestationObject
		// • Assertion    → credentialID + rawClientDataJSON + rawAuthenticatorData + signature + userID
		let completeAuthorizationRequest: CompleteAuthorizationRequest? =
			switch authorization.credential {
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

	/// Called when `ASAuthorizationController` fails or is cancelled.
	///
	/// Publishes either a ``AuthorizationServiceError/canceled(isPrefillAssisted:)`` (for user cancellations)
	/// or a ``AuthorizationServiceError/failed(isPrefillAssisted:errorMessage:underlyingError:)`` on ``onComplete``.
	///
	/// - Parameters:
	///   - controller: The controller that failed.
	///   - error: The error describing the failure reason.
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
	/// A pre-configured instance used for SwiftUI previews.
	static var preview: some AuthorizationService {
		AuthorizationServiceImpl()
	}
}

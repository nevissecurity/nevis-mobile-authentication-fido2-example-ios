//
// FIDO2 Example
//
// Copyright © 2026 Nevis Security AG. All rights reserved.
//

import Combine
import Foundation

/// Manages the lifecycle of a FIDO2 authorization session.
///
/// Wraps both `ASAuthorizationController` (for passkey flows) and
/// `ASWebAuthenticationSession` (for web-based OAuth/OIDC flows).
/// Results are published on ``onComplete``.
protocol AuthorizationService {
	/// A publisher that emits the result of the most recent authorization attempt.
	/// Subscribers receive either a ``CompleteAuthorizationRequest`` on success or an ``AuthorizationServiceError`` on failure/cancellation.
	var onComplete: AnyPublisher<Result<CompleteAuthorizationRequest, AuthorizationServiceError>, Never> { get }

	/// Starts a passkey registration or authentication flow using `ASAuthorizationController`.
	///
	/// If a session is already active it is cancelled before starting the new one.
	///
	/// - Parameters:
	///   - startAuthorizationResponse: The server options returned by the start use case.
	///   - isAutoFillAssisted: Pass `true` to perform an auto-fill assisted assertion
	///     (QuickType bar passkey suggestion) instead of the modal sheet.
	func start(_ startAuthorizationResponse: StartAuthorizationResponse, isAutoFillAssisted: Bool)

	/// Cancels the currently active `ASAuthorizationController` session, if any.
	func cancel()

	/// Starts a web-based OAuth/OIDC authorization flow using `ASWebAuthenticationSession`.
	///
	/// The session opens `url` in the system browser and waits for the callback redirect
	/// matching `callbackUrlScheme`. The result is published on ``onComplete``.
	///
	/// - Parameters:
	///   - url: The authorization URL to open.
	///   - callbackUrlScheme: The URL scheme the server redirects to after authorization.
	func startWeb(url: URL, callbackUrlScheme: String)

	/// Cancels the currently active `ASWebAuthenticationSession`, if any.
	func cancelWeb()
}

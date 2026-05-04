//
// FIDO2 Example
//
// Copyright © 2026 Nevis Security AG. All rights reserved.
//

import Foundation

/// Errors surfaced by ``AuthorizationService`` when a FIDO2 or web authorization
/// attempt fails or is explicitly cancelled by the user.
enum AuthorizationServiceError: Error {
	/// The authorization attempt failed with an optional descriptive message or underlying error.
	/// - Parameter isPrefillAssisted: `true` if the failure occurred during auto-fill assisted flow.
	case failed(isPrefillAssisted: Bool, errorMessage: String? = nil, underlyingError: Error? = nil)
	/// The user explicitly cancelled the authorization (e.g. dismissed the passkey sheet).
	/// - Parameter isPrefillAssisted: `true` if the cancellation occurred during auto-fill assisted flow.
	case canceled(isPrefillAssisted: Bool)
}

// MARK: - LocalizedError

extension AuthorizationServiceError: LocalizedError {
	/// A human-readable description of the error, conforming to `LocalizedError`.
	var errorDescription: String? {
		switch self {
			case let .failed(isPrefillAssisted, errorMessage, underlyingError):
				"Authorization failed\(isPrefillAssisted ? " with prefill assistance" : "").\((errorMessage != nil) ? " \(errorMessage!)" : "")\(underlyingError?.localizedDescription != nil ? "  \(underlyingError!.localizedDescription)" : "")"
			case let .canceled(isPrefillAssisted):
				"Authorization canceled\(isPrefillAssisted ? " with prefill assistance" : "")."
		}
	}
}

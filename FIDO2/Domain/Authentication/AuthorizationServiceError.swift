//
// FIDO2 Example
//
// Copyright © 2025 Nevis Security AG. All rights reserved.
//

import Foundation

enum AuthorizationServiceError: Error {
	case failed(isPrefillAssisted: Bool, errorMessage: String? = nil, underlyingError: Error? = nil)
	case canceled(isPrefillAssisted: Bool)
}

// MARK: - LocalizedError

extension AuthorizationServiceError: LocalizedError {
	var errorDescription: String? {
		switch self {
		case let .failed(isPrefillAssisted, errorMessage, underlyingError):
			"Authorization failed\(isPrefillAssisted ? " with prefill assistance" : "").\((errorMessage != nil) ? " \(errorMessage!)" : "")\(underlyingError?.localizedDescription != nil ? "  \(underlyingError!.localizedDescription)" : "")"
		case let .canceled(isPrefillAssisted):
			"Authorization canceled\(isPrefillAssisted ? " with prefill assistance" : "")."
		}
	}
}

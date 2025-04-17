//
// FIDO2 Example
//
// Copyright © 2025 Nevis Security AG. All rights reserved.
//

import Foundation

enum AuthorizationServiceError: Error {
	case failed(isPrefillAssisted: Bool, underlyingError: Error?)
	case canceled(isPrefillAssisted: Bool)
}

// MARK: - LocalizedError

extension AuthorizationServiceError: LocalizedError {
	var errorDescription: String? {
		switch self {
		case let .failed(isPrefillAssisted, underlyingError):
			"Authorization failed\(isPrefillAssisted ? "with prefill assistance" : ""). \(underlyingError?.localizedDescription ?? "")"
		case let .canceled(isPrefillAssisted):
			"Authorization canceled\(isPrefillAssisted ? "with prefill assistance" : "")."
		}
	}
}

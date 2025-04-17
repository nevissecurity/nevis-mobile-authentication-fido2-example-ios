//
// FIDO2 Example
//
// Copyright © 2025 Nevis Security AG. All rights reserved.
//

import Foundation

enum AppError: Error {
	case network(message: String? = nil, underlying: Error? = nil)
	case request(message: String? = nil, underlying: Error? = nil)
	case missingData(message: String? = nil, underlying: Error? = nil)
	case invalidConversion(message: String? = nil, underlying: Error? = nil)
	case unknown(message: String? = nil, underlying: Error? = nil)
}

// MARK: - LocalizedError

extension AppError: LocalizedError {
	private func errorDescription(_ text: String, message: String? = nil, underlying: Error? = nil) -> String? {
		if let message {
			return message
		}
		if let underlying {
			return underlying.localizedDescription
		}
		return "\(text)\(message != nil ? "; \(message!)" : "")\(underlying != nil ? "; \(underlying!.localizedDescription)" : "")"
	}

	var errorDescription: String? {
		switch self {
		case let .network(message, underlying):
			errorDescription("Network error", message: message, underlying: underlying)
		case let .request(message, underlying):
			errorDescription("Request error", message: message, underlying: underlying)
		case let .missingData(message, underlying):
			errorDescription("Missing data", message: message, underlying: underlying)
		case let .invalidConversion(message, underlying):
			errorDescription("Invalid conversion", message: message, underlying: underlying)
		case let .unknown(message, underlying):
			errorDescription("Unknown error", message: message, underlying: underlying)
		}
	}
}

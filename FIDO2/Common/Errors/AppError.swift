//
// FIDO2 Example
//
// Copyright © 2026 Nevis Security AG. All rights reserved.
//

import Foundation

/// The unified error type used throughout the application.
///
/// All layers convert their lower-level errors into `AppError` before surfacing
/// them to the presentation layer.
enum AppError: Error {
	/// Thrown when the app configuration (host, token, entitlements) is invalid or missing.
	case configuration(message: String? = nil, underlying: Error? = nil)
	/// Thrown when a network request fails at the transport layer (e.g. no connectivity, TLS error).
	case network(message: String? = nil, underlying: Error? = nil)
	/// Thrown when the server returns an application-level error (non-2xx status or error payload).
	case request(message: String? = nil, underlying: Error? = nil)
	/// Thrown when a required piece of data is absent in the response (e.g. attestation object).
	case missingData(message: String? = nil, underlying: Error? = nil)
	/// Thrown when a data conversion fails (e.g. Base64URL decoding, type casting).
	case invalidConversion(message: String? = nil, underlying: Error? = nil)
	/// Thrown when a requested operation is not supported by the current device or configuration.
	case notSupported(message: String? = nil, underlying: Error? = nil)
	/// Thrown as a catch-all for unexpected errors that don't fit any other category.
	case unknown(message: String? = nil, underlying: Error? = nil)
}

// MARK: - LocalizedError

extension AppError: LocalizedError {
	/// Builds a human-readable error description from the given components.
	///
	/// Priority: `message` → `underlying.localizedDescription` → composed fallback string.
	///
	/// - Parameters:
	///   - text: A default prefix used in the fallback string (e.g. `"Network error"`).
	///   - message: An optional explicit message that takes precedence over everything else.
	///   - underlying: An optional wrapped error whose `localizedDescription` is used when no explicit message is provided.
	/// - Returns: A non-nil human-readable string describing the error.
	private func errorDescription(_ text: String, message: String? = nil, underlying: Error? = nil) -> String? {
		if let message {
			return message
		}
		if let underlying {
			return underlying.localizedDescription
		}
		return "\(text)\(message != nil ? "; \(message!)" : "")\(underlying != nil ? "; \(underlying!.localizedDescription)" : "")"
	}

	/// A human-readable description of the error, conforming to `LocalizedError`.
	///
	/// Delegates to the private `errorDescription(_:message:underlying:)` helper for each case.
	var errorDescription: String? {
		switch self {
			case let .configuration(message, underlying):
				errorDescription("Configuration error", message: message, underlying: underlying)
			case let .network(message, underlying):
				errorDescription("Network error", message: message, underlying: underlying)
			case let .request(message, underlying):
				errorDescription("Request error", message: message, underlying: underlying)
			case let .missingData(message, underlying):
				errorDescription("Missing data", message: message, underlying: underlying)
			case let .invalidConversion(message, underlying):
				errorDescription("Invalid conversion", message: message, underlying: underlying)
			case let .notSupported(message, underlying):
				errorDescription("Not supported", message: message, underlying: underlying)
			case let .unknown(message, underlying):
				errorDescription("Unknown error", message: message, underlying: underlying)
		}
	}
}

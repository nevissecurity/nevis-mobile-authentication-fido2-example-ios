//
// FIDO2 Example
//
// Copyright © 2026 Nevis Security AG. All rights reserved.
//

import Foundation

public extension Data {
	/// Creates a `Data` instance from a Base64URL-encoded string.
	///
	/// Base64URL differs from standard Base64 in two ways:
	/// - `-` is used instead of `+`
	/// - `_` is used instead of `/`
	/// - Padding (`=`) may be omitted
	///
	/// This initializer reverses those substitutions and re-adds padding before
	/// calling the standard `Data(base64Encoded:)` initializer.
	///
	/// - Parameter base64URLEncoded: A Base64URL-encoded string, with or without padding.
	init?(base64URLEncoded: String) {
		var appendCount = 4 - (base64URLEncoded.count % 4)
		var base64String: String = base64URLEncoded
		/*
		 * base64url format can drop the "=" which is used as padding
		 * They are added as padding to ensure a particular length of string
		 * below, I calculate if they are missing and add the appropriate
		 * number of "="
		 */
		while appendCount > 0, appendCount < 4 {
			base64String = "\(base64String)="
			appendCount -= 1
		}
		base64String = base64String.replacingOccurrences(of: "-", with: "+")
		base64String = base64String.replacingOccurrences(of: "_", with: "/")

		self.init(base64Encoded: base64String)
	}

	/// Returns a Base64URL-encoded string representation of the data.
	///
	/// Converts standard Base64 output to Base64URL format by replacing `+` with `-`,
	/// `/` with `_`, and stripping the `=` padding.
	func toBase64UrlEncodedString() -> String {
		base64EncodedString()
			.replacingOccurrences(of: "+", with: "-")
			.replacingOccurrences(of: "/", with: "_")
			.replacingOccurrences(of: "=", with: "")
	}
}

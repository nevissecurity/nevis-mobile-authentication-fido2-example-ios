//
// FIDO2 Example
//
// Copyright © 2026 Nevis Security AG. All rights reserved.
//

import Foundation

extension String {
	/// A standard Base64-encoded representation of the string (using UTF-8 encoding).
	var base64Encoded: String {
		Data(utf8).base64EncodedString()
	}

	/// The `Data` obtained by Base64-decoding this string, or `nil` if the string is not valid Base64.
	var base64DecodedData: Data? {
		Data(base64Encoded: self)
	}

	/// The `Data` obtained by Base64URL-decoding this string (handles `-`/`_` and missing padding).
	var base64UrlDecodedData: Data? {
		Data(base64URLEncoded: self)
	}

	/// The UTF-8 string obtained by Base64-decoding this string, or `nil` if decoding fails.
	var base64Decoded: String? {
		guard let data = Data(base64Encoded: self) else { return nil }
		return String(data: data, encoding: .utf8)
	}

	/// A Base64URL-encoded representation of this string (replaces `+`→`-`, `/`→`_`, strips `=`).
	var base64URLEncodedString: String {
		base64Encoded
			.replacingOccurrences(of: "+", with: "-")
			.replacingOccurrences(of: "/", with: "_")
			.replacingOccurrences(of: "=", with: "")
	}
}

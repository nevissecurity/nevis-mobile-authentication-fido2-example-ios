//
// FIDO2 Example
//
// Copyright © 2025 Nevis Security AG. All rights reserved.
//

import Foundation

extension String {
	var base64Encoded: String {
		Data(utf8).base64EncodedString()
	}

	var base64DecodedData: Data? {
		Data(base64Encoded: self)
	}

	var base64UrlDecodedData: Data? {
		Data(base64URLEncoded: self)
	}

	var base64Decoded: String? {
		guard let data = Data(base64Encoded: self) else { return nil }
		return String(data: data, encoding: .utf8)
	}

	var base64URLEncodedString: String {
		base64Encoded
			.replacingOccurrences(of: "+", with: "-")
			.replacingOccurrences(of: "/", with: "_")
			.replacingOccurrences(of: "=", with: "")
	}
}

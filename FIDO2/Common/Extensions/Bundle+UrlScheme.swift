//
// FIDO2 Example
//
// Copyright © 2026. Nevis Security AG. All rights reserved.
//

import Foundation

extension Bundle {
	/// Returns the URL schemes defined in the Info.plist.
	var urlSchemes: [String] {
		guard
			let types = infoDictionary?["CFBundleURLTypes"] as? [[String: Any]],
			let schemes = types.first?["CFBundleURLSchemes"] as? [String]
		else {
			return []
		}
		return schemes
	}
}

//
// FIDO2 Example
//
// Copyright © 2026. Nevis Security AG. All rights reserved.
//

import Foundation

extension URL {
	/// A sentinel empty URL (`https://`) used as a safe non-optional fallback
	/// when a URL cannot be constructed from configuration values.
	static let empty = URL(string: "https://")!
}

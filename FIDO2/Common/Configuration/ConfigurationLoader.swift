//
// FIDO2 PoC
//
// Copyright © 2025 NEVIS. All rights reserved.
//

import Combine

protocol ConfigurationLoader {
	static var shared: ConfigurationLoader { get }

	func get() async throws -> AppConfiguration
}

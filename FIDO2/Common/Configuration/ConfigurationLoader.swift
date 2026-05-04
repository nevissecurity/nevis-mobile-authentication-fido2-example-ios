//
// FIDO2 Example
//
// Copyright © 2026 Nevis Security AG. All rights reserved.
//

/// Provides the application configuration loaded from `Configuration.plist`.
protocol ConfigurationLoader {
	/// The loaded application configuration.
	///
	/// - Throws: An error if the configuration file is missing or malformed.
	var config: AppConfiguration { get throws }
}

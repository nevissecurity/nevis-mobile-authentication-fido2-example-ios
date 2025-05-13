//
// FIDO2 Example App
//
// Copyright © 2025 Nevis Security AG. All rights reserved.
//

import Foundation

final class ConfigurationLoaderImpl {
	private(set) var appConfig: AppConfiguration?
}

extension ConfigurationLoaderImpl: ConfigurationLoader {
	var config: AppConfiguration {
		get throws {
			guard let appConfig else {
				let appConfig = try read()
				self.appConfig = appConfig
				return appConfig
			}
			return appConfig
		}
	}
}

private extension ConfigurationLoaderImpl {
	/// Asynchronously loads the configuration from the app bundle's Resources.
	/// - Returns: An instance of `AppConfiguration` decoded from the plist.
	func read() throws -> AppConfiguration {
		// Locate the configuration file in the app bundle.
		guard let url = Bundle.main.url(forResource: "Configuration", withExtension: "plist") else {
			throw URLError(.fileDoesNotExist, userInfo: [NSLocalizedDescriptionKey: "Configuration file not found in app bundle."])
		}

		let data: Data = try Data(contentsOf: url)

		// Decode the data using PropertyListDecoder.
		return try PropertyListDecoder().decode(AppConfiguration.self, from: data)
	}
}

// MARK: - Preview

extension ConfigurationLoaderImpl {
	static var preview: ConfigurationLoaderImpl {
		let config = ConfigurationLoaderImpl()
		config.appConfig = AppConfiguration(host: "<host>", accessToken: "<AccessToken>")
		return config
	}
}

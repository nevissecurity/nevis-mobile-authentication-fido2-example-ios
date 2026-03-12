//
// FIDO2 Example
//
// Copyright © 2026 Nevis Security AG. All rights reserved.
//

import Foundation

/// Concrete implementation of ``ConfigurationLoader`` that reads `Configuration.plist`
/// from the main bundle and caches the decoded result.
final class ConfigurationLoaderImpl {
	/// In-memory cache of the decoded configuration, populated on first access via ``config``.
	private(set) var appConfig: AppConfiguration?
}

// MARK: - ConfigurationLoader

extension ConfigurationLoaderImpl: ConfigurationLoader {
	/// Returns the cached configuration if available; otherwise reads and caches it from the bundle.
	///
	/// - Throws: ``AppError/configuration(message:underlying:)`` if the plist is missing or cannot be decoded.
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

// MARK: - Private Interface

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
	/// A pre-configured instance used for SwiftUI previews.
	///
	/// Injects placeholder values so the preview canvas does not require a real `Configuration.plist`.
	static var preview: ConfigurationLoaderImpl {
		let config = ConfigurationLoaderImpl()
		config.appConfig = AppConfiguration(host: "<host>", accessToken: "<AccessToken>", pathForAuthorization: "<Path>")
		return config
	}
}

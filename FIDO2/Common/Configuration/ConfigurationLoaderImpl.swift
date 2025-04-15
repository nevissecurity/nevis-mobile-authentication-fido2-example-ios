//
// FIDO2 PoC
//
// Copyright © 2025 NEVIS. All rights reserved.
//

import Combine
import Foundation

class ConfigurationLoaderImpl: ConfigurationLoader {
	static var shared: ConfigurationLoader = ConfigurationLoaderImpl() // Singleton instance for convenience.

	private var config: AppConfiguration?

	/// Asynchronously retrieves the configuration
	func get() async throws -> AppConfiguration {
		if let config = config {
			return config
		} else {
			return try await load()
		}
	}
}

extension ConfigurationLoaderImpl {
	/// Asynchronously loads the configuration from the app bundle's Resources.
	/// - Returns: An instance of `AppConfiguration` decoded from the plist.
	func load() async throws -> AppConfiguration {
		// Locate the configuration file in the app bundle.
		guard let url = Bundle.main.url(forResource: "Configuration", withExtension: "plist") else {
			throw NSError(domain: "ConfigLoader",
						  code: 404,
						  userInfo: [NSLocalizedDescriptionKey: "Configuration file not found in app bundle."])
		}

		// Read the data asynchronously using a background thread.
		let data: Data = try await withCheckedThrowingContinuation { continuation in
			DispatchQueue.global(qos: .background).async {
				do {
					let data = try Data(contentsOf: url)
					continuation.resume(returning: data)
				} catch {
					continuation.resume(throwing: error)
				}
			}
		}

		// Decode the data using PropertyListDecoder.
		let config = try PropertyListDecoder().decode(AppConfiguration.self, from: data)
		self.config = config // Cache the loaded configuration for future access.
		return config
	}
}

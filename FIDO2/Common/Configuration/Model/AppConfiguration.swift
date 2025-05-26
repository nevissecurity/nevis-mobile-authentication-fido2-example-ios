//
// FIDO2 Example
//
// Copyright © 2025 Nevis Security AG. All rights reserved.
//

import Foundation

/// Object that contains the configuration for the app.
struct AppConfiguration: Codable, Sendable {
	let host: String
	let accessToken: String
	let pathForAuthorization: String
}

// MARK: - Helper

extension AppConfiguration {
	var baseUrl: URL {
		URL(string: "https://\(host)/") ?? .empty
	}

	var webAuthorizationUrl: URL {
		URL(string: "\(baseUrl.absoluteString)\(pathForAuthorization)") ?? .empty
	}
}

// MARK: - Preview

extension AppConfiguration {
	static var preview: AppConfiguration {
		AppConfiguration(
			host: "test.com",
			accessToken: "",
			pathForAuthorization: "path",
		)
	}
}

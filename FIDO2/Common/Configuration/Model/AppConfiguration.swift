//
// FIDO2 Example
//
// Copyright © 2026 Nevis Security AG. All rights reserved.
//

import Foundation

/// The app's runtime configuration decoded from `Configuration.plist`.
///
/// All values are read-only after initialization; the plist is the single source of truth.
struct AppConfiguration: Codable, Sendable {
	/// The hostname of the Authentication Cloud instance (without scheme), e.g. `"myinstance.mauth.nevis.cloud"`.
	let host: String
	/// The bearer token used to authenticate API requests against the Authentication Cloud.
	let accessToken: String
	/// The URL path component appended to the base URL to open the web-based authorization page.
	let pathForAuthorization: String
}

// MARK: - Helper

extension AppConfiguration {
	/// The HTTPS base URL constructed from ``host``.
	var baseUrl: URL {
		URL(string: "https://\(host)/") ?? .empty
	}

	/// The full URL for the web-based OAuth/OIDC authorization page.
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

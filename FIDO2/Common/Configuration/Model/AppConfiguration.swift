//
// FIDO2 PoC
//
// Copyright © 2025 NEVIS. All rights reserved.
//

/// Object that contains the configuration for the app.
struct AppConfiguration: Codable {
	let baseUrl: String
	let startEnrollPath: String
	let completeEnrollPath: String
	let startAuthenticatePath: String
	let completeAuthenticatePath: String
}

extension AppConfiguration {
	static var preview: AppConfiguration {
		return AppConfiguration(
			baseUrl: "https://test.com",
			startEnrollPath: "start/enrollment",
			completeEnrollPath: "complete/enroll",
			startAuthenticatePath: "start/authenticate",
			completeAuthenticatePath: "complete/authenticate"
		)
	}
}

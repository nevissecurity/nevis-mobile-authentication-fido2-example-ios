//
// FIDO2 PoC
//
// Copyright © 2025 NEVIS. All rights reserved.
//

import Foundation
import Moya

// Define the API end-point as a Moya Target
enum Fireball: TargetType, AccessTokenAuthorizable {
	// Static configuration that must be set before making any requests.
	static var appConfig: AppConfiguration!

	var authorizationType: AuthorizationType? {
		return .bearer
	}

	case startEnrollment(request: StartEnrollRequest)
	case completeEnrollment(request: CompleteEnrollRequest)
	case startAuthentication(request: StartApprovalRequest)
	case completeAuthentication(request: CompleteApprovalRequest)

	var baseURL: URL {
		return URL(string: Fireball.appConfig.baseUrl)!
	}

	var path: String {
		switch self {
		case .startEnrollment:
			return Fireball.appConfig.startEnrollPath
		case .completeEnrollment:
			return Fireball.appConfig.completeEnrollPath
		case .startAuthentication:
			return Fireball.appConfig.startAuthenticatePath
		case .completeAuthentication:
			return Fireball.appConfig.completeAuthenticatePath
		}
	}

	var method: Moya.Method {
		return .post
	}

	var task: Task {
		switch self {
		case .startEnrollment(let request):
			return .requestJSONEncodable(request)
		case .completeEnrollment(let request):
			return .requestJSONEncodable(request)
		case .startAuthentication(let request):
			return .requestJSONEncodable(request)
		case .completeAuthentication(let request):
			return .requestJSONEncodable(request)
		}
	}

	var headers: [String: String]? {
		return [
			"Content-Type": "application/json",
		]
	}

	var sampleData: Data {
		return Data() // Provide sample data if needed for testing
	}
}

//
// FIDO2 Example
//
// Copyright © 2025 Nevis Security AG. All rights reserved.
//

import Foundation
import Moya
import SwinjectAutoregistration

// Define the API end-point as a Moya Target
enum AuthenticationCloud: TargetType, AccessTokenAuthorizable {
	case registration(request: RegistrationRequest)
	case attestation(request: AttestationRequest)
	case approval(request: ApprovalRequest)
	case assertion(request: AssertionRequest)

	var baseURL: URL {
		(try? (dependencyContainer ~> ConfigurationLoader.self).config.baseUrl) ?? URL(string: "https://")!
	}

	var path: String {
		switch self {
		case .registration:
			"api/v1/users/enroll"
		case .attestation:
			"_app/attestation/result"
		case .approval:
			"api/v1/approval"
		case .assertion:
			"_app/assertion/result"
		}
	}

	var method: Moya.Method {
		.post
	}

	var task: Task {
		switch self {
		case let .registration(request):
			.requestJSONEncodable(request)
		case let .attestation(request):
			.requestJSONEncodable(request)
		case let .approval(request):
			.requestJSONEncodable(request)
		case let .assertion(request):
			.requestJSONEncodable(request)
		}
	}

	var headers: [String: String]? {
		[
			"Content-Type": "application/json",
		]
	}

	var authorizationType: AuthorizationType? {
		.bearer
	}
}

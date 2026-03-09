//
// FIDO2 Example
//
// Copyright © 2026 Nevis Security AG. All rights reserved.
//

import Foundation
import Moya
import SwinjectAutoregistration

// Define the API end-point as a Moya Target
/// Moya `TargetType` enum describing every Authentication Cloud API endpoint.
///
/// Each case carries a typed request DTO and is consumed by `MoyaProvider<AuthenticationCloud>`.
/// All endpoints use Bearer token authorization via `AccessTokenPlugin`.
enum AuthenticationCloud: TargetType, AccessTokenAuthorizable {
	/// Registration ceremony initiation — POST `/api/v1/users/enroll`.
	case registration(request: RegistrationRequest)
	/// Registration ceremony completion — POST `/_app/attestation/result`.
	case attestation(request: AttestationRequest)
	/// Authentication ceremony initiation — POST `/api/v1/approval`.
	case approval(request: ApprovalRequest)
	/// Authentication ceremony completion — POST `/_app/assertion/result`.
	case assertion(request: AssertionRequest)
	/// Token introspection — POST `/api/v1/introspect`.
	case introspect(request: IntrospectRequest)

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
		case .introspect:
			"api/v1/introspect"
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
		case let .introspect(request):
			.requestParameters(parameters: request.asDictionary, encoding: URLEncoding.httpBody)
		}
	}

	var headers: [String: String]? {
		switch self {
		case .introspect:
			[
				"Content-Type": "application/x-www-form-urlencoded",
			]
		default:
			[
				"Content-Type": "application/json",
			]
		}
	}

	/// The Bearer authorization type used by all endpoints.
	var authorizationType: AuthorizationType? {
		.bearer
	}
}

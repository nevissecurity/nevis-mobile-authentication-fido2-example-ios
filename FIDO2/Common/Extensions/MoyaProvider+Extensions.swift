//
// FIDO2 Example
//
// Copyright © 2026 Nevis Security AG. All rights reserved.
//

import Alamofire
import Combine
import Moya

// Extend MoyaProvider to support Combine publishing if not already available
extension MoyaProvider {
	var userAgent: String {
		HTTPHeader.defaultUserAgent.value
	}

	/// Wraps the callback-based `MoyaProvider.request(_:completion:)` in a Combine `Future`.
	///
	/// - Parameter target: The Moya `TargetType` describing the API endpoint.
	/// - Returns: A publisher that emits a single `Response` on success or a `MoyaError` on failure.
	func requestPublisher(_ target: Target) -> AnyPublisher<Response, MoyaError> {
		Future { [weak self] promise in
			self?.request(target, completion: promise)
		}
		.eraseToAnyPublisher()
	}
}

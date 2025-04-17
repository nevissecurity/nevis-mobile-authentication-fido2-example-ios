//
// FIDO2 Example
//
// Copyright © 2025 Nevis Security AG. All rights reserved.
//

import Alamofire
import Combine
import Moya

// Extend MoyaProvider to support Combine publishing if not already available
extension MoyaProvider {
	var userAgent: String {
		HTTPHeader.defaultUserAgent.value
	}

	func requestPublisher(_ target: Target) -> AnyPublisher<Response, MoyaError> {
		Future { [weak self] promise in
			self?.request(target, completion: promise)
		}
		.eraseToAnyPublisher()
	}
}

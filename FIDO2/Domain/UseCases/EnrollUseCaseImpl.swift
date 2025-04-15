//
// FIDO2 PoC
//
// Copyright © 2025 NEVIS. All rights reserved.
//

import Combine

final class EnrollUseCaseImpl: EnrollUseCase {
	private let fido2Repository: Fido2Repository

	init(fido2Repository: Fido2Repository) {
		self.fido2Repository = fido2Repository
	}

	func execute(username: String) -> AnyPublisher<AsAuthorizationType, any Error> {
		fido2Repository.enroll(username: username)
	}
}

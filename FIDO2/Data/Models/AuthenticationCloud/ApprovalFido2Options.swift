//
// FIDO2 Example App
//
// Copyright © 2025 Nevis Security AG. All rights reserved.
//

struct ApprovalFido2Options: Codable {
	var userVerification: UserVerification?
}

extension ApprovalFido2Options {
	init?(from entity: Fido2Options?) {
		guard let entity else { return nil }

		self.userVerification = UserVerification(from: entity.userVerificationRequirement)
	}
}

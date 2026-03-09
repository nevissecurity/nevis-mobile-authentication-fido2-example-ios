//
// FIDO2 Example
//
// Copyright © 2026 Nevis Security AG. All rights reserved.
//

/// DTO for the optional FIDO2 policy options sent with an approval (authentication) request.
struct ApprovalFido2Options: Codable {
	var userVerification: UserVerification?
}

// MARK: - Mapping

extension ApprovalFido2Options {
	// MARK: - From Domain

	static func map(from options: Fido2Options?) -> ApprovalFido2Options? {
		guard let options else { return nil }

		return .init(
			userVerification: .map(from: options.userVerificationRequirement),
		)
	}
}

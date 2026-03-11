//
// FIDO2 Example
//
// Copyright © 2026 Nevis Security AG. All rights reserved.
//

/// DTO for the optional FIDO2 policy options sent with an approval (authentication) request.
struct ApprovalFido2Options: Codable {
	/// The user verification requirement to include in the approval request, or `nil` to use the server default.
	var userVerification: UserVerification?
}

// MARK: - Mapping

extension ApprovalFido2Options {
	// MARK: - From Domain

	/// Creates an ``ApprovalFido2Options`` from the given domain ``Fido2Options``.
	///
	/// - Parameter options: The domain options to convert, or `nil` to indicate no options.
	/// - Returns: An ``ApprovalFido2Options`` with mapped fields, or `nil` if `options` is `nil`.
	static func map(from options: Fido2Options?) -> ApprovalFido2Options? {
		guard let options else { return nil }

		return .init(
			userVerification: .map(from: options.userVerificationRequirement),
		)
	}
}

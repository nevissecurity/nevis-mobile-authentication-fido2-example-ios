//
// FIDO2 Example
//
// Copyright © 2026 Nevis Security AG. All rights reserved.
//

/// A user-facing notification message shown at the bottom of a ``Fido2Section``.
struct Message {
	/// Determines the visual style of the message (color, icon).
	enum MessageType {
		/// A successful operation result, rendered in green.
		case success
		/// A failed operation result, rendered in red.
		case error
	}

	var type: MessageType = .success
	let title: String
	var details: String?
}

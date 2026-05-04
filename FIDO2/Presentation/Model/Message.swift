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

	/// The visual style of the message banner (success = green, error = red).
	var type: MessageType = .success
	/// The primary message text shown in bold.
	let title: String
	/// Optional secondary text providing further detail below the title.
	var details: String?
}

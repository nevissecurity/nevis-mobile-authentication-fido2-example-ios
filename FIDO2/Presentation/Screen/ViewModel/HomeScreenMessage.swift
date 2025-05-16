//
// FIDO2 Example
//
// Copyright © 2025 Nevis Security AG. All rights reserved.
//

struct HomeScreenMessage {
	enum MessageType {
		case success
		case error
	}

	var type: MessageType = .success
	let title: String
	var details: String?
}

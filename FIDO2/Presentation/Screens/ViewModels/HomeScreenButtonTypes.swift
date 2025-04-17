//
// FIDO2 Example
//
// Copyright © 2025 Nevis Security AG. All rights reserved.
//

extension HomeScreenViewModel {
	enum ButtonType: String, CaseIterable, Equatable {
		case register = "Register"
		case authenticate = "Authenticate"
		case authenticateUsernameless = "Authenticate (Usernameless)"
	}
}

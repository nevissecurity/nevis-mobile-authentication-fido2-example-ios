//
// FIDO2 Example
//
// Copyright © 2025 Nevis Security AG. All rights reserved.
//

extension HomeScreenViewModel {
	struct Section: Identifiable {
		enum Id: String, CaseIterable, Equatable {
			case register = "Register"
			case authenticate = "Authenticate"
			case authenticateUsernameless = "Authenticate (Usernameless)"
		}

		let id: Id
		let title: String
	}
}

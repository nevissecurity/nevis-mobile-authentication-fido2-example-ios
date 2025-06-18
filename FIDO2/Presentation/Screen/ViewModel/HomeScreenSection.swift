//
// FIDO2 Example
//
// Copyright © 2025 Nevis Security AG. All rights reserved.
//

extension HomeScreenViewModel {
	struct Section: Identifiable {
		enum Id: Int, CaseIterable, Equatable {
			case registration = 0
			case authentication = 1
			case authenticationUsernameless = 2
			case authorizationViaWebview = 3
		}

		// MARK: Properties

		let id: Id
		let title: String
		let buttons: [SectionButton]
	}
}

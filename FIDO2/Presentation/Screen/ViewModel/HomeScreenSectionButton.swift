//
// FIDO2 Example
//
// Copyright © 2025. Nevis Security AG. All rights reserved.
//

extension HomeScreenViewModel {
	struct SectionButton: Identifiable {
		enum Id: Int, CaseIterable, Equatable {
			case registration = 0
			case authentication = 1
			case authenticationUsernameless = 2
			case registrationViaWebview = 3
			case authenticationViaWebview = 4
		}

		// MARK: Properties

		let id: Id
		let label: String

		// MARK: Initializer

		init(_ id: Id, _ label: String) {
			self.id = id
			self.label = label
		}
	}
}

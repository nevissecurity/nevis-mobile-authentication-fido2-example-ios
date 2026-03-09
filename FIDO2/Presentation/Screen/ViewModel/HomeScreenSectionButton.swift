//
// FIDO2 Example
//
// Copyright © 2026. Nevis Security AG. All rights reserved.
//

/// An action button within a ``HomeScreenViewModel/Section``.
extension HomeScreenViewModel {
	struct SectionButton: Identifiable {
		/// Uniquely identifies each section button.
		enum Id: Int, CaseIterable, Equatable {
			/// Register a new passkey for the entered username.
			case registration = 0
			/// Authenticate with a passkey for the entered username.
			case authentication = 1
			/// Authenticate with a discoverable passkey (no username required).
			case authenticationUsernameless = 2
			/// Register via the web-based OAuth flow.
			case registrationViaWebview = 3
			/// Authenticate via the web-based OAuth flow.
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

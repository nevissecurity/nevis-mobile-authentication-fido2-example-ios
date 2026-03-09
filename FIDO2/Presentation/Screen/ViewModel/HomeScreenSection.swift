//
// FIDO2 Example
//
// Copyright © 2026 Nevis Security AG. All rights reserved.
//

/// A section shown in the home screen list, grouping related buttons together.
extension HomeScreenViewModel {
	struct Section: Identifiable {
		/// Uniquely identifies each home screen section.
		enum Id: Int, CaseIterable, Equatable {
			/// The passkey registration section.
			case registration = 0
			/// The named-user passkey authentication section.
			case authentication = 1
			/// The usernameless/discoverable passkey authentication section.
			case authenticationUsernameless = 2
			/// The web-based OAuth/OIDC authorization section.
			case authorizationViaWebview = 3
		}

		// MARK: Properties

		let id: Id
		let title: String
		let buttons: [SectionButton]
	}
}

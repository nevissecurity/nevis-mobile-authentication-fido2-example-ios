//
// FIDO2 Example
//
// Copyright © 2026 Nevis Security AG. All rights reserved.
//

import SwiftUI

/// The application entry point.
///
/// Bootstraps the SwiftUI scene graph with `HomeScreenView` as the root view.
@main
struct FIDO2App: App {
	var body: some Scene {
		WindowGroup {
			HomeScreenView()
		}
	}
}

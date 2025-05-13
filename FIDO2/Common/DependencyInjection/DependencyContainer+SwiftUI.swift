//
// FIDO2 Example
//
// Copyright © 2025 Nevis Security AG. All rights reserved.
//

import SwiftUI
@preconcurrency import SwinjectAutoregistration

struct HomeScreenViewModelKey: EnvironmentKey {
	static var defaultValue: HomeScreenViewModel {
		DependencyProvider.shared.container ~> HomeScreenViewModel.self
	}
}

extension EnvironmentValues {
	var homeScreenViewModel: HomeScreenViewModel {
		get { self[HomeScreenViewModelKey.self] }
		set { self[HomeScreenViewModelKey.self] = newValue }
	}
}

//
// FIDO2 Example App
//
// Copyright © 2025 Nevis Security AG. All rights reserved.
//

import Combine

protocol ConfigurationLoader {
	var config: AppConfiguration { get throws }
}

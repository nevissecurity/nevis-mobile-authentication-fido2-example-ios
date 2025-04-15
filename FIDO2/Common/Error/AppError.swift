//
// FIDO2 PoC
//
// Copyright © 2025 NEVIS. All rights reserved.
//

// TODO: extend with LocalizedError extension
enum AppError: Error {
	case unknown
	case fido2Error(Error)
}

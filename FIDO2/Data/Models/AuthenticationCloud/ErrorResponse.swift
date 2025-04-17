//
// FIDO2 Example App
//
// Copyright © 2025 Nevis Security AG. All rights reserved.
//

struct ErrorResponse: Decodable {
	let error: String
	let message: String?
	let status: Int
}

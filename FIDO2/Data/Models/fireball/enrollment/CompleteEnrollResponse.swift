//
// FIDO2 PoC
//
// Copyright © 2025 NEVIS. All rights reserved.
//

import Foundation

struct CompleteEnrollResponse: Decodable {
	let errorMessage: String
	let fido2SessionId: String
	let status: String
	let token: String
}

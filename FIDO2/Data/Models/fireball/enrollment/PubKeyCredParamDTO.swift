//
// FIDO2 PoC
//
// Copyright © 2025 NEVIS. All rights reserved.
//

struct PubKeyCredParamDTO: Codable {
	let alg: Int
	let type: String
}

extension PubKeyCredParamDTO {
	func toDomain() -> PubKeyCredParam {
		PubKeyCredParam(
			alg: alg,
			type: type
		)
	}
}

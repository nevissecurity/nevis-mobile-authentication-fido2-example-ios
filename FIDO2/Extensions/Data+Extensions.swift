//
// NevisAccessApp
//
// Copyright © 2022. NEVIS. All rights reserved.
//

import Foundation

extension Data {
	public init?(base64URLEncoded: String) {
		var appendCount: Int = 4 - (base64URLEncoded.count % 4)
		var base64String: String = base64URLEncoded
		/*
		 * base64url format can drop the "=" which is used as padding
		 * They are added as padding to ensure a particular length of string
		 * below, I calculate if they are missing and add the appropriate
		 * number of "="
		 */
		while appendCount > 0 && appendCount < 4 {
			base64String = "\(base64String)="
			appendCount -= 1
		}
		base64String = base64String.replacingOccurrences(of: "-", with: "+")
		base64String = base64String.replacingOccurrences(of: "_", with: "/")

		self.init(base64Encoded: base64String)
	}
}

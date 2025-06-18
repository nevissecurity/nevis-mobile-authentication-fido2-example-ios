//
// Date+Formatted.swift
// FIDO2 Example
//
// Copyright © 2025 Nevis Security AG. All rights reserved.
//

import Foundation

extension Date {
	init(epochInMillis: Int64) {
		self = Date(timeIntervalSince1970: TimeInterval(epochInMillis / 1000))
	}

	var formatted: String {
		let formatter = DateFormatter()
		formatter.dateStyle = .medium
		formatter.timeStyle = .medium
		formatter.timeZone = TimeZone.current
		return formatter.string(from: self)
	}
}

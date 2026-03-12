//
// Date+Formatted.swift
// FIDO2 Example
//
// Copyright © 2026 Nevis Security AG. All rights reserved.
//

import Foundation

extension Date {
	/// Creates a `Date` from a Unix epoch timestamp expressed in milliseconds.
	///
	/// - Parameter epochInMillis: Milliseconds since January 1, 1970 UTC.
	init(epochInMillis: Int64) {
		self = Date(timeIntervalSince1970: TimeInterval(epochInMillis / 1000))
	}

	/// A human-readable date/time string in the device's current locale and time zone,
	/// using medium date and time styles (e.g. "Jan 1, 2025 at 12:00:00 PM").
	var formatted: String {
		let formatter = DateFormatter()
		formatter.dateStyle = .medium
		formatter.timeStyle = .medium
		formatter.timeZone = TimeZone.current
		return formatter.string(from: self)
	}
}

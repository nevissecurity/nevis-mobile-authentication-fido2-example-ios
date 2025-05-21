//
// FIDO2 Example
//
// Copyright © 2025. Nevis Security AG. All rights reserved.
//

import UIKit

// MARK: - Determining the human readable name of the device.

extension UIDevice {
	private static var modelIdentifier: String {
		var systemInfo = utsname()
		uname(&systemInfo)
		let machineMirror = Mirror(reflecting: systemInfo.machine)
		return machineMirror.children.reduce("") { identifier, element in
			guard let value = element.value as? Int8, value != 0 else { return identifier }
			return identifier + String(UnicodeScalar(UInt8(value)))
		}
	}

	private static var modelName: String {
		let identifier = modelIdentifier

		return switch identifier {
		case "i386", "x86_64", "arm64":
			"Simulator (\(ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] ?? identifier))"
		default:
			identifier
		}
	}

	static var deviceName: String {
		let dateFormatter = DateFormatter()
		dateFormatter.locale = Locale(identifier: "en_US_POSIX")
		dateFormatter.dateFormat = "dd MMM yyyy HH:mm:ss"
		return "iOS (\(UIDevice.modelName)) \(dateFormatter.string(from: Date()))"
	}
}

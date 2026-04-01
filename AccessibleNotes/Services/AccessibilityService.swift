import UIKit

enum AccessibilityService {
    static func announce(_ message: String) {
        UIAccessibility.post(notification: .announcement, argument: message)
    }
}

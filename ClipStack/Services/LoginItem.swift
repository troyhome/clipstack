import Foundation
import ServiceManagement

/// Turns "open at login" on or off (shows up in System Settings > General > Login Items).
enum LoginItem {
    static var isEnabled: Bool {
        SMAppService.mainApp.status == .enabled
    }

    static func set(_ enabled: Bool) {
        do {
            if enabled {
                try SMAppService.mainApp.register()
            } else {
                try SMAppService.mainApp.unregister()
            }
        } catch {
            NSLog("ClipStack: could not change login item: \(error)")
        }
    }
}

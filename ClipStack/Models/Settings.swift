import Carbon.HIToolbox
import Foundation

/// Keys for values saved in UserDefaults.
enum SettingsKeys {
    static let maxItems = "maxItems"
    static let shortcut = "shortcut"
    static let didFirstLaunch = "didFirstLaunch"
}

enum HistoryLimit {
    static let choices = [10, 25, 50, 100]
    static let defaultValue = 25

    static var current: Int {
        let value = UserDefaults.standard.integer(forKey: SettingsKeys.maxItems)
        return value > 0 ? value : defaultValue
    }
}

/// The keyboard shortcut that opens the clipboard list. All use the V key.
enum ShortcutChoice: String, CaseIterable, Identifiable {
    case commandShiftV
    case controlOptionV
    case commandOptionV

    var id: String { rawValue }

    var label: String {
        switch self {
        case .commandShiftV: return "⌘⇧V  (Command-Shift-V)"
        case .controlOptionV: return "⌃⌥V  (Control-Option-V)"
        case .commandOptionV: return "⌘⌥V  (Command-Option-V)"
        }
    }

    var shortLabel: String {
        switch self {
        case .commandShiftV: return "⌘⇧V"
        case .controlOptionV: return "⌃⌥V"
        case .commandOptionV: return "⌘⌥V"
        }
    }

    var keyCode: UInt32 { UInt32(kVK_ANSI_V) }

    var carbonModifiers: UInt32 {
        switch self {
        case .commandShiftV: return UInt32(cmdKey | shiftKey)
        case .controlOptionV: return UInt32(controlKey | optionKey)
        case .commandOptionV: return UInt32(cmdKey | optionKey)
        }
    }

    static var current: ShortcutChoice {
        let raw = UserDefaults.standard.string(forKey: SettingsKeys.shortcut) ?? ""
        return ShortcutChoice(rawValue: raw) ?? .commandShiftV
    }
}

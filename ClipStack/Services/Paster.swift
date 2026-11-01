import AppKit
import ApplicationServices
import Carbon.HIToolbox

/// Puts a history item back on the clipboard and, if allowed, presses Command-V for the user.
/// Pressing keys for the user needs Accessibility permission (System Settings >
/// Privacy & Security > Accessibility). Without it ClipStack only copies.
///
/// The App Store build (APPSTORE flag) never presses keys: it only copies, and the
/// user presses Command-V. Apple's review has rejected clipboard apps that paste for you.
@MainActor
enum Paster {
    #if APPSTORE
    static let autoPaste = false
    #else
    static let autoPaste = true
    #endif

    static func write(_ item: ClipItem, store: HistoryStore) {
        let pasteboard = NSPasteboard.general
        pasteboard.clearContents()
        switch item.kind {
        case .text:
            pasteboard.setString(item.text ?? "", forType: .string)
        case .image:
            if let url = store.imageURL(for: item), let image = NSImage(contentsOf: url) {
                pasteboard.writeObjects([image])
            }
        case .files:
            pasteboard.writeObjects((item.fileURLs ?? []) as [NSURL])
        }
    }

    #if APPSTORE
    static var canPaste: Bool { false }
    static func askForPermission() {}
    static func openAccessibilitySettings() {}
    static func pressCommandV() {}
    #else
    static var canPaste: Bool { AXIsProcessTrusted() }

    /// Shows the system dialog that leads to the Accessibility settings.
    static func askForPermission() {
        // Same as kAXTrustedCheckOptionPrompt, written out so it compiles the same on every Xcode version.
        _ = AXIsProcessTrustedWithOptions(["AXTrustedCheckOptionPrompt": true] as CFDictionary)
    }

    static func openAccessibilitySettings() {
        let link = "x-apple.systempreferences:com.apple.preference.security?Privacy_Accessibility"
        if let url = URL(string: link) { NSWorkspace.shared.open(url) }
    }

    /// Sends Command-V to whichever app is in front.
    static func pressCommandV() {
        let source = CGEventSource(stateID: .combinedSessionState)
        let key = CGKeyCode(kVK_ANSI_V)
        let down = CGEvent(keyboardEventSource: source, virtualKey: key, keyDown: true)
        let up = CGEvent(keyboardEventSource: source, virtualKey: key, keyDown: false)
        down?.flags = .maskCommand
        up?.flags = .maskCommand
        down?.post(tap: .cghidEventTap)
        up?.post(tap: .cghidEventTap)
    }
    #endif
}

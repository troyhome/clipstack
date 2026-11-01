import AppKit

/// Watches the system clipboard. macOS has no "clipboard changed" notification,
/// so this checks a cheap counter twice a second.
@MainActor
final class ClipboardMonitor {
    var onCapture: ((Capture, String?) -> Void)?

    private let pasteboard = NSPasteboard.general
    private var lastChangeCount: Int
    private var timer: Timer?

    init() {
        lastChangeCount = pasteboard.changeCount
    }

    func start() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { [weak self] _ in
            MainActor.assumeIsolated { self?.check() }
        }
    }

    /// Call after ClipStack itself writes to the clipboard so it isn't recorded twice.
    func ignoreCurrentChange() {
        lastChangeCount = pasteboard.changeCount
    }

    private func check() {
        let count = pasteboard.changeCount
        guard count != lastChangeCount else { return }
        lastChangeCount = count
        guard let capture = ClipboardReader.read(pasteboard) else { return }
        let app = NSWorkspace.shared.frontmostApplication?.localizedName
        onCapture?(capture, app)
    }
}

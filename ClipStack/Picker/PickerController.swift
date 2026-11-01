import AppKit
import SwiftUI

/// Shows and hides the clipboard list: where the user last dragged it, or else near the mouse pointer.
@MainActor
final class PickerController {
    static let size = NSSize(width: 380, height: 460)

    private let store: HistoryStore
    private let onChoose: (ClipItem) -> Void
    private var panel: PickerPanel?
    private var moveObserver: NSObjectProtocol?

    init(store: HistoryStore, onChoose: @escaping (ClipItem) -> Void) {
        self.store = store
        self.onChoose = onChoose
    }

    func toggle() {
        if panel != nil { close() } else { show() }
    }

    func show() {
        let model = PickerViewModel(store: store)
        model.onChoose = { [weak self] item in
            self?.close()
            self?.onChoose(item)
        }
        model.onClose = { [weak self] in self?.close() }

        let panel = PickerPanel(model: model)
        panel.contentView = NSHostingView(rootView: PickerView(model: model, store: store))
        panel.setFrame(savedFrame() ?? frameNearMouse(), display: true)
        panel.makeKeyAndOrderFront(nil)
        self.panel = panel

        // Remember where the user drags the list.
        moveObserver = NotificationCenter.default.addObserver(
            forName: NSWindow.didMoveNotification, object: panel, queue: .main
        ) { [weak panel] _ in
            MainActor.assumeIsolated {
                guard let origin = panel?.frame.origin else { return }
                UserDefaults.standard.set(NSStringFromPoint(origin), forKey: SettingsKeys.pickerOrigin)
            }
        }
    }

    func close() {
        // Clear first: hiding the panel triggers resignKey, which calls close() again.
        let closing = panel
        panel = nil
        if let moveObserver { NotificationCenter.default.removeObserver(moveObserver) }
        moveObserver = nil
        closing?.orderOut(nil)
    }

    /// Forgets the dragged position, so the list opens near the mouse again.
    static func resetPosition() {
        UserDefaults.standard.removeObject(forKey: SettingsKeys.pickerOrigin)
    }

    /// The spot the user dragged the list to, if it still fits on a connected screen.
    private func savedFrame() -> NSRect? {
        guard let saved = UserDefaults.standard.string(forKey: SettingsKeys.pickerOrigin) else { return nil }
        let frame = NSRect(origin: NSPointFromString(saved), size: Self.size)
        let fits = NSScreen.screens.contains { $0.visibleFrame.contains(frame) }
        return fits ? frame : nil
    }

    private func frameNearMouse() -> NSRect {
        let size = Self.size
        let mouse = NSEvent.mouseLocation
        let screen = NSScreen.screens.first { NSMouseInRect(mouse, $0.frame, false) } ?? NSScreen.main
        let visible = screen?.visibleFrame ?? NSRect(origin: .zero, size: size)
        let margin: CGFloat = 8
        var x = mouse.x - size.width / 2
        var y = mouse.y - size.height - 12
        x = min(max(x, visible.minX + margin), visible.maxX - size.width - margin)
        y = min(max(y, visible.minY + margin), visible.maxY - size.height - margin)
        return NSRect(x: x, y: y, width: size.width, height: size.height)
    }
}

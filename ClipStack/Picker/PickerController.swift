import AppKit
import SwiftUI

/// Shows and hides the clipboard list near the mouse pointer.
@MainActor
final class PickerController {
    static let size = NSSize(width: 380, height: 460)

    private let store: HistoryStore
    private let onChoose: (ClipItem) -> Void
    private var panel: PickerPanel?

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
        panel.setFrame(frameNearMouse(), display: true)
        panel.makeKeyAndOrderFront(nil)
        self.panel = panel
    }

    func close() {
        // Clear first: hiding the panel triggers resignKey, which calls close() again.
        let closing = panel
        panel = nil
        closing?.orderOut(nil)
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

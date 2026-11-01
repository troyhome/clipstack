import AppKit

/// Floating window for the clipboard list. It takes keyboard input without
/// making ClipStack the active app, so the app you were typing in stays in front
/// and receives the paste.
final class PickerPanel: NSPanel {
    private let model: PickerViewModel

    init(model: PickerViewModel) {
        self.model = model
        super.init(contentRect: .zero,
                   styleMask: [.nonactivatingPanel, .borderless, .fullSizeContentView],
                   backing: .buffered,
                   defer: false)
        isFloatingPanel = true
        level = .popUpMenu
        collectionBehavior = [.canJoinAllSpaces, .fullScreenAuxiliary, .transient]
        backgroundColor = .clear
        isOpaque = false
        hasShadow = true
        hidesOnDeactivate = false
        isReleasedWhenClosed = false
    }

    override var canBecomeKey: Bool { true }
    override var canBecomeMain: Bool { false }

    /// Clicking anywhere else closes the list.
    override func resignKey() {
        super.resignKey()
        model.onClose?()
    }

    /// Handle keys here so they work no matter which view has focus.
    override func sendEvent(_ event: NSEvent) {
        if event.type == .keyDown, model.handleKey(event) { return }
        super.sendEvent(event)
    }
}

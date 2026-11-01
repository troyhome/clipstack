import Carbon.HIToolbox
import Foundation

/// A system-wide keyboard shortcut using Carbon's RegisterEventHotKey.
/// This does not need Accessibility permission and does not watch other keys.
final class HotKey {
    private static var actions: [UInt32: () -> Void] = [:]
    private static var handlerInstalled = false
    private static let signature: OSType = 0x434C5053 // "CLPS"

    private let id: UInt32
    private var ref: EventHotKeyRef?

    init(keyCode: UInt32, modifiers: UInt32, id: UInt32 = 1, action: @escaping () -> Void) {
        self.id = id
        Self.installHandlerIfNeeded()
        Self.actions[id] = action
        let hotKeyID = EventHotKeyID(signature: Self.signature, id: id)
        let status = RegisterEventHotKey(keyCode, modifiers, hotKeyID,
                                         GetApplicationEventTarget(), 0, &ref)
        if status != noErr {
            NSLog("ClipStack: could not register shortcut (error \(status)). Another app may be using it.")
        }
    }

    deinit {
        if let ref { UnregisterEventHotKey(ref) }
        Self.actions[id] = nil
    }

    private static func installHandlerIfNeeded() {
        guard !handlerInstalled else { return }
        handlerInstalled = true
        var spec = EventTypeSpec(eventClass: OSType(kEventClassKeyboard),
                                 eventKind: UInt32(kEventHotKeyPressed))
        InstallEventHandler(GetApplicationEventTarget(), { _, event, _ in
            var hotKeyID = EventHotKeyID()
            GetEventParameter(event,
                              EventParamName(kEventParamDirectObject),
                              EventParamType(typeEventHotKeyID),
                              nil,
                              MemoryLayout<EventHotKeyID>.size,
                              nil,
                              &hotKeyID)
            let pressedID = hotKeyID.id
            DispatchQueue.main.async { HotKey.actions[pressedID]?() }
            return noErr
        }, 1, &spec, nil, nil)
    }
}

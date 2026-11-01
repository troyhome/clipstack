import AppKit

/// Connects the pieces: clipboard watcher -> history, shortcut -> picker, picker -> clipboard.
@MainActor
final class AppController: ObservableObject {
    let store = HistoryStore()
    private let monitor = ClipboardMonitor()
    private var hotKey: HotKey?
    private lazy var picker = PickerController(store: store) { [weak self] item in
        self?.copy(item)
    }

    func start() {
        monitor.onCapture = { [weak self] capture, app in
            self?.store.add(capture, from: app)
        }
        monitor.start()
        registerHotKey()
        firstLaunchSetup()
    }

    /// (Re)registers the shortcut chosen in Settings.
    func registerHotKey() {
        hotKey = nil
        let choice = ShortcutChoice.current
        hotKey = HotKey(keyCode: choice.keyCode, modifiers: choice.carbonModifiers) { [weak self] in
            self?.showPicker()
        }
    }

    func showPicker() {
        picker.toggle()
    }

    /// Puts the item on the clipboard. The user pastes it with Command-V.
    func copy(_ item: ClipItem) {
        ClipboardWriter.write(item, store: store)
        monitor.ignoreCurrentChange()
        store.promote(item)
    }

    /// First launch: explain how it works and ask before opening at login (App Store rule).
    private func firstLaunchSetup() {
        let defaults = UserDefaults.standard
        guard !defaults.bool(forKey: SettingsKeys.didFirstLaunch) else { return }
        defaults.set(true, forKey: SettingsKeys.didFirstLaunch)

        let alert = NSAlert()
        alert.messageText = "Welcome to ClipStack"
        alert.informativeText = """
            ClipStack remembers what you copy. Press \(ShortcutChoice.current.shortLabel) to see the list, \
            pick an item, then press Command-V to paste it.

            Open ClipStack automatically when you log in?
            """
        alert.addButton(withTitle: "Open at Login")
        alert.addButton(withTitle: "Not Now")
        NSApp.activate(ignoringOtherApps: true)
        if alert.runModal() == .alertFirstButtonReturn {
            LoginItem.set(true)
        }
    }
}

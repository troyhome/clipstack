import AppKit

/// Connects the pieces: clipboard watcher -> history, shortcut -> picker, picker -> paste.
@MainActor
final class AppController: ObservableObject {
    let store = HistoryStore()
    private let monitor = ClipboardMonitor()
    private var hotKey: HotKey?
    private lazy var picker = PickerController(store: store) { [weak self] item in
        self?.paste(item)
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

    /// Puts the item on the clipboard and pastes it into the app in front.
    func paste(_ item: ClipItem) {
        Paster.write(item, store: store)
        monitor.ignoreCurrentChange()
        store.promote(item)
        // App Store build: copy only, the user presses Command-V.
        guard Paster.autoPaste else { return }
        guard Paster.canPaste else {
            Paster.askForPermission()
            return
        }
        // Short pause so the picker is gone and the other app has keyboard focus again.
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.08) {
            Paster.pressCommandV()
        }
    }

    private func firstLaunchSetup() {
        let defaults = UserDefaults.standard
        guard !defaults.bool(forKey: SettingsKeys.didFirstLaunch) else { return }
        defaults.set(true, forKey: SettingsKeys.didFirstLaunch)
        #if APPSTORE
        // App Store rules: ask before opening at login.
        welcome()
        #else
        // Only the installed copy should open at login, not test builds.
        if Bundle.main.bundlePath.hasPrefix("/Applications/") {
            LoginItem.set(true)
        }
        if !Paster.canPaste {
            Paster.askForPermission()
        }
        #endif
    }

    #if APPSTORE
    /// First-launch window: how it works, and whether to open at login.
    private func welcome() {
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
    #endif
}

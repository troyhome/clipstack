import SwiftUI

/// The menu under the clipboard icon in the menu bar.
struct MenuBarMenu: View {
    @ObservedObject var controller: AppController
    @ObservedObject var store: HistoryStore
    @AppStorage(SettingsKeys.shortcut) private var shortcut = ShortcutChoice.commandShiftV

    var body: some View {
        Button("Show Clipboard History  (\(shortcut.shortLabel))") {
            controller.showPicker()
        }
        Divider()
        if store.items.isEmpty {
            Text("Nothing copied yet")
        } else {
            ForEach(store.items.prefix(10)) { item in
                Button(item.pinned ? "Pinned: " + item.menuTitle : item.menuTitle) {
                    controller.paste(item)
                }
            }
        }
        Divider()
        SettingsLink {
            Text("Settings…")
        }
        .keyboardShortcut(",")
        Button("Quit ClipStack") {
            NSApp.terminate(nil)
        }
        .keyboardShortcut("q")
    }
}

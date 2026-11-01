import SwiftUI

struct SettingsView: View {
    @ObservedObject var controller: AppController

    @AppStorage(SettingsKeys.maxItems) private var maxItems = HistoryLimit.defaultValue
    @AppStorage(SettingsKeys.shortcut) private var shortcut = ShortcutChoice.commandShiftV
    @State private var openAtLogin = LoginItem.isEnabled

    var body: some View {
        Form {
            Section("General") {
                Toggle("Open ClipStack at login", isOn: $openAtLogin)
                    .onChange(of: openAtLogin) { _, newValue in
                        LoginItem.set(newValue)
                    }
                Picker("Shortcut", selection: $shortcut) {
                    ForEach(ShortcutChoice.allCases) { choice in
                        Text(choice.label).tag(choice)
                    }
                }
                .onChange(of: shortcut) { _, _ in controller.registerHotKey() }
                Picker("Remember", selection: $maxItems) {
                    ForEach(HistoryLimit.choices, id: \.self) { count in
                        Text("Last \(count) items").tag(count)
                    }
                }
                .onChange(of: maxItems) { _, _ in controller.store.trimToLimit() }
            }

            Section("List position") {
                Text("Drag the top bar of the list to move it. It opens there next time.")
                Button("Open near the mouse again") { PickerController.resetPosition() }
            }

            Section("Pasting") {
                Text("Pick an item and ClipStack copies it. Then press Command-V to paste.")
            }

            Section("History") {
                Button("Clear history (pinned items stay)", role: .destructive) {
                    controller.store.clearUnpinned()
                }
            }
        }
        .formStyle(.grouped)
        .frame(width: 460)
        .onAppear {
            NSApp.activate(ignoringOtherApps: true)
            openAtLogin = LoginItem.isEnabled
        }
    }
}

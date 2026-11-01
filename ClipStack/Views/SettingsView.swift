import SwiftUI

struct SettingsView: View {
    @ObservedObject var controller: AppController

    @AppStorage(SettingsKeys.maxItems) private var maxItems = HistoryLimit.defaultValue
    @AppStorage(SettingsKeys.shortcut) private var shortcut = ShortcutChoice.commandShiftV
    @State private var openAtLogin = LoginItem.isEnabled
    @State private var canPaste = Paster.canPaste

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

            Section("Pasting") {
                HStack {
                    Text(canPaste
                         ? "ClipStack pastes for you."
                         : "ClipStack can only copy. Allow it under Accessibility to paste for you.")
                    Spacer()
                    if !canPaste {
                        Button("Open Settings") { Paster.openAccessibilitySettings() }
                    }
                }
                Button("Check again") { canPaste = Paster.canPaste }
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
            canPaste = Paster.canPaste
        }
    }
}

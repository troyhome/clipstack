import SwiftUI

@main
struct ClipStackApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate

    var body: some Scene {
        MenuBarExtra("ClipStack", systemImage: "list.clipboard") {
            MenuBarMenu(controller: appDelegate.controller, store: appDelegate.controller.store)
        }
        Settings {
            SettingsView(controller: appDelegate.controller)
        }
    }
}

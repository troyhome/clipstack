import AppKit

@MainActor
final class AppDelegate: NSObject, NSApplicationDelegate {
    let controller = AppController()

    func applicationDidFinishLaunching(_ notification: Notification) {
        controller.start()
    }
}

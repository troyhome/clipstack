import AppKit

/// Puts a history item back on the clipboard. The user then presses Command-V.
/// (ClipStack is an App Store app: it never presses keys for the user.)
@MainActor
enum ClipboardWriter {
    static func write(_ item: ClipItem, store: HistoryStore) {
        let pasteboard = NSPasteboard.general
        pasteboard.clearContents()
        switch item.kind {
        case .text:
            pasteboard.setString(item.text ?? "", forType: .string)
        case .image:
            if let url = store.imageURL(for: item), let image = NSImage(contentsOf: url) {
                pasteboard.writeObjects([image])
            }
        case .files:
            pasteboard.writeObjects((item.fileURLs ?? []) as [NSURL])
        }
    }
}

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
            let urls = item.fileURLs ?? []
            // A copied picture (for example from Photos): offer both the file and the picture,
            // so it pastes into Finder as a file and into Mail, Messages or Notes as a picture.
            // If the original file is gone by now, only the picture is offered.
            if let imageURL = store.imageURL(for: item), let png = try? Data(contentsOf: imageURL) {
                let entry = NSPasteboardItem()
                if let url = urls.first, FileManager.default.fileExists(atPath: url.path) {
                    entry.setString(url.absoluteString, forType: .fileURL)
                }
                entry.setData(png, forType: .png)
                pasteboard.writeObjects([entry])
            } else {
                pasteboard.writeObjects(urls as [NSURL])
            }
        }
    }
}

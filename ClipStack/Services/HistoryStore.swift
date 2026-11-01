import CryptoKit
import Foundation

/// Keeps the clipboard history in memory and saves it to
/// ~/Library/Application Support/ClipStack (history.json + Images folder).
@MainActor
final class HistoryStore: ObservableObject {
    @Published private(set) var items: [ClipItem] = []

    private let folder: URL
    private var imagesFolder: URL { folder.appendingPathComponent("Images", isDirectory: true) }
    private var historyFile: URL { folder.appendingPathComponent("history.json") }

    init() {
        let support = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)[0]
        folder = support.appendingPathComponent("ClipStack", isDirectory: true)
        try? FileManager.default.createDirectory(at: imagesFolder, withIntermediateDirectories: true)
        load()
    }

    // MARK: - Adding

    func add(_ capture: Capture, from app: String?) {
        let signature = Self.signature(for: capture)

        // Same thing copied again: move it to the top instead of adding a duplicate.
        if let index = items.firstIndex(where: { $0.signature == signature }) {
            var existing = items.remove(at: index)
            existing.date = Date()
            existing.sourceApp = app ?? existing.sourceApp
            // A picture copied before the preview worked: add the preview now.
            if case .files(_, let preview?) = capture, existing.imageFile == nil {
                existing.imageFile = saveImage(preview, id: existing.id)
            }
            items.insert(existing, at: 0)
            save()
            return
        }

        let id = UUID()
        var item = ClipItem(id: id, kind: .text, date: Date(), signature: signature)
        item.sourceApp = app
        switch capture {
        case .text(let string):
            item.kind = .text
            item.text = string
        case .files(let urls, let preview):
            item.kind = .files
            item.fileURLs = urls
            if let preview {
                // Optional: if saving the picture fails, the item still works as a file.
                item.imageFile = saveImage(preview, id: id)
            }
        case .image(let png):
            guard let name = saveImage(png, id: id) else { return }
            item.kind = .image
            item.imageFile = name
        }
        items.insert(item, at: 0)
        trimToLimit()
        save()
    }

    /// Saves PNG data in the Images folder and returns its file name, or nil if it failed.
    private func saveImage(_ png: Data, id: UUID) -> String? {
        let name = "\(id.uuidString).png"
        do {
            try png.write(to: imagesFolder.appendingPathComponent(name), options: .atomic)
            return name
        } catch {
            NSLog("ClipStack: could not save image: \(error)")
            return nil
        }
    }

    // MARK: - Changing

    /// Moves an item to the top (used after pasting it).
    func promote(_ item: ClipItem) {
        guard let index = items.firstIndex(where: { $0.id == item.id }) else { return }
        var moved = items.remove(at: index)
        moved.date = Date()
        items.insert(moved, at: 0)
        save()
    }

    func togglePin(_ item: ClipItem) {
        guard let index = items.firstIndex(where: { $0.id == item.id }) else { return }
        items[index].pinned.toggle()
        trimToLimit()
        save()
    }

    func delete(_ item: ClipItem) {
        guard let index = items.firstIndex(where: { $0.id == item.id }) else { return }
        removeFiles(of: items.remove(at: index))
        save()
    }

    /// Removes everything except pinned items.
    func clearUnpinned() {
        for item in items where !item.pinned { removeFiles(of: item) }
        items.removeAll { !$0.pinned }
        save()
    }

    /// Keeps at most `HistoryLimit.current` unpinned items. Pinned items always stay.
    func trimToLimit() {
        let limit = HistoryLimit.current
        var unpinnedSeen = 0
        var kept: [ClipItem] = []
        for item in items {
            if item.pinned {
                kept.append(item)
            } else if unpinnedSeen < limit {
                unpinnedSeen += 1
                kept.append(item)
            } else {
                removeFiles(of: item)
            }
        }
        if kept.count != items.count {
            items = kept
            save()
        }
    }

    func imageURL(for item: ClipItem) -> URL? {
        guard let name = item.imageFile else { return nil }
        return imagesFolder.appendingPathComponent(name)
    }

    // MARK: - Saving

    private func save() {
        do {
            let data = try JSONEncoder().encode(items)
            try data.write(to: historyFile, options: .atomic)
        } catch {
            NSLog("ClipStack: could not save history: \(error)")
        }
    }

    private func load() {
        guard let data = try? Data(contentsOf: historyFile),
              let saved = try? JSONDecoder().decode([ClipItem].self, from: data) else { return }
        items = saved
    }

    private func removeFiles(of item: ClipItem) {
        if let url = imageURL(for: item) {
            try? FileManager.default.removeItem(at: url)
        }
    }

    private static func signature(for capture: Capture) -> String {
        switch capture {
        case .text(let string):
            return "t:" + hash(Data(string.utf8))
        case .image(let png):
            return "i:" + hash(png)
        case .files(let urls, _):
            return "f:" + urls.map(\.path).joined(separator: "\n")
        }
    }

    private static func hash(_ data: Data) -> String {
        SHA256.hash(data: data).map { String(format: "%02x", $0) }.joined()
    }
}

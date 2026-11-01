import Foundation

/// What kind of thing was copied.
enum ClipKind: String, Codable {
    case text, image, files
}

/// One entry in the clipboard history.
struct ClipItem: Identifiable, Codable, Equatable {
    let id: UUID
    var kind: ClipKind
    /// The copied text (for `.text`) or nil.
    var text: String?
    /// File name of the saved PNG inside the history's Images folder (for `.image`).
    var imageFile: String?
    /// Copied files from Finder (for `.files`).
    var fileURLs: [URL]?
    /// The app that was in front when the copy happened.
    var sourceApp: String?
    var date: Date
    var pinned: Bool = false
    /// Used to spot duplicates: copying the same thing again moves it to the top.
    var signature: String

    /// Text used by type-to-search in the picker.
    var searchText: String {
        switch kind {
        case .text: return text ?? ""
        case .image: return "image picture"
        case .files: return (fileURLs ?? []).map(\.lastPathComponent).joined(separator: " ")
        }
    }

    /// Short one-line title for the menu bar menu.
    var menuTitle: String {
        switch kind {
        case .text:
            let firstLine = (text ?? "")
                .trimmingCharacters(in: .whitespacesAndNewlines)
                .components(separatedBy: .newlines).first ?? ""
            return firstLine.count > 50 ? String(firstLine.prefix(50)) + "…" : firstLine
        case .image:
            return "Image"
        case .files:
            let names = (fileURLs ?? []).map(\.lastPathComponent)
            if names.count == 1 { return names[0] }
            return "\(names.count) files"
        }
    }
}

import AppKit
import Carbon.HIToolbox

/// Keyboard handling, search text and selection for the clipboard list.
@MainActor
final class PickerViewModel: ObservableObject {
    @Published var query = ""
    @Published var selection = 0

    var onChoose: ((ClipItem) -> Void)?
    var onClose: (() -> Void)?

    let store: HistoryStore

    init(store: HistoryStore) {
        self.store = store
    }

    /// Items matching the typed search (all items if nothing typed).
    var visibleItems: [ClipItem] {
        guard !query.isEmpty else { return store.items }
        return store.items.filter { $0.searchText.localizedCaseInsensitiveContains(query) }
    }

    func choose(at index: Int) {
        let items = visibleItems
        guard items.indices.contains(index) else { return }
        onChoose?(items[index])
    }

    func move(_ step: Int) {
        let count = visibleItems.count
        guard count > 0 else { return }
        selection = min(max(selection + step, 0), count - 1)
    }

    /// Returns true if the key was used.
    func handleKey(_ event: NSEvent) -> Bool {
        let flags = event.modifierFlags.intersection(.deviceIndependentFlagsMask)
        let command = flags.contains(.command)

        switch Int(event.keyCode) {
        case kVK_Escape:
            if query.isEmpty { onClose?() } else { query = ""; selection = 0 }
            return true
        case kVK_Return, kVK_ANSI_KeypadEnter:
            choose(at: selection)
            return true
        case kVK_DownArrow:
            move(1)
            return true
        case kVK_UpArrow:
            move(-1)
            return true
        case kVK_Delete:
            if command {
                deleteSelected()
            } else if !query.isEmpty {
                query.removeLast()
                selection = 0
            }
            return true
        default:
            break
        }

        if command {
            let key = event.charactersIgnoringModifiers?.lowercased() ?? ""
            if let number = Int(key), (1...9).contains(number) {
                choose(at: number - 1)
                return true
            }
            if key == "p" {
                pinSelected()
                return true
            }
            return false
        }

        // Plain typing goes into the search.
        if flags.isDisjoint(with: [.control, .option]),
           let characters = event.characters, !characters.isEmpty,
           characters.unicodeScalars.allSatisfy({ Self.isTypable($0) }) {
            query += characters
            selection = 0
            return true
        }
        return false
    }

    /// Letters, digits and symbols. Not control keys, and not the arrow/function keys,
    /// which macOS reports as private characters (U+F700 to U+F8FF).
    private static func isTypable(_ scalar: Unicode.Scalar) -> Bool {
        if CharacterSet.controlCharacters.contains(scalar) { return false }
        return !(0xF700...0xF8FF).contains(scalar.value)
    }

    func pin(_ item: ClipItem) {
        store.togglePin(item)
    }

    private func pinSelected() {
        let items = visibleItems
        guard items.indices.contains(selection) else { return }
        store.togglePin(items[selection])
    }

    private func deleteSelected() {
        let items = visibleItems
        guard items.indices.contains(selection) else { return }
        store.delete(items[selection])
        selection = min(selection, max(visibleItems.count - 1, 0))
    }
}

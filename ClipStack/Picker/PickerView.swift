import SwiftUI

/// The clipboard list shown by the shortcut.
struct PickerView: View {
    @ObservedObject var model: PickerViewModel
    @ObservedObject var store: HistoryStore

    var body: some View {
        let items = model.visibleItems
        VStack(spacing: 0) {
            searchBar(count: items.count)
            Divider()
            if items.isEmpty {
                emptyState
            } else {
                list(items)
            }
            Divider()
            footer
        }
        .frame(width: PickerController.size.width, height: PickerController.size.height)
        .background(.regularMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .overlay(RoundedRectangle(cornerRadius: 12).strokeBorder(Color.primary.opacity(0.12)))
    }

    private func searchBar(count: Int) -> some View {
        HStack(spacing: 8) {
            Image(systemName: "magnifyingglass").foregroundStyle(.secondary)
            Text(model.query.isEmpty ? "Type to search" : model.query)
                .foregroundStyle(model.query.isEmpty ? .secondary : .primary)
                .lineLimit(1)
            Spacer()
            Text("\(count)").font(.caption).foregroundStyle(.secondary)
            Image(systemName: "line.3.horizontal")
                .foregroundStyle(.tertiary)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 10)
        // Drag the top bar to move the list. It opens there next time.
        .overlay(WindowDragArea())
        .help("Drag to move the list")
    }

    private func list(_ items: [ClipItem]) -> some View {
        ScrollViewReader { proxy in
            ScrollView {
                LazyVStack(spacing: 2) {
                    ForEach(Array(items.enumerated()), id: \.element.id) { index, item in
                        ClipRow(item: item,
                                index: index,
                                isSelected: index == model.selection,
                                imageURL: store.imageURL(for: item),
                                onPin: { model.pin(item) })
                            .id(item.id)
                            .contentShape(Rectangle())
                            .onTapGesture { model.choose(at: index) }
                            .onHover { inside in if inside { model.selection = index } }
                    }
                }
                .padding(6)
            }
            .onChange(of: model.selection) { _, newValue in
                if items.indices.contains(newValue) {
                    proxy.scrollTo(items[newValue].id)
                }
            }
        }
    }

    private var emptyState: some View {
        VStack(spacing: 6) {
            Spacer()
            Image(systemName: "list.clipboard").font(.largeTitle).foregroundStyle(.secondary)
            Text(model.query.isEmpty ? "Nothing copied yet" : "No matches")
                .foregroundStyle(.secondary)
            Spacer()
        }
        .frame(maxWidth: .infinity)
    }

    private var footer: some View {
        Text("Return copy   ⌘1-9 quick copy   ⌘P pin   ⌘⌫ remove   Esc close")
            .font(.caption2)
            .foregroundStyle(.secondary)
            .padding(.vertical, 6)
    }
}

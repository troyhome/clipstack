import SwiftUI

/// One row in the clipboard list.
struct ClipRow: View {
    let item: ClipItem
    let index: Int
    let isSelected: Bool
    let imageURL: URL?
    let onPin: () -> Void

    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            content
            Spacer(minLength: 4)
            VStack(alignment: .trailing, spacing: 6) {
                if index < 9 {
                    Text("⌘\(index + 1)").font(.caption2).foregroundStyle(.secondary)
                }
                Button(action: onPin) {
                    Image(systemName: item.pinned ? "pin.fill" : "pin")
                        .foregroundStyle(item.pinned ? Color.accentColor : .secondary)
                }
                .buttonStyle(.plain)
                .help(item.pinned ? "Unpin" : "Pin (kept forever)")
            }
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 8)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(isSelected ? Color.accentColor.opacity(0.25) : Color.primary.opacity(0.04))
        )
    }

    @ViewBuilder
    private var content: some View {
        VStack(alignment: .leading, spacing: 4) {
            switch item.kind {
            case .text:
                Text(item.text ?? "")
                    .lineLimit(3)
                    .font(.system(size: 13))
            case .image:
                if let imageURL, let image = NSImage(contentsOf: imageURL) {
                    Image(nsImage: image)
                        .resizable()
                        .scaledToFit()
                        .frame(maxHeight: 80, alignment: .leading)
                        .clipShape(RoundedRectangle(cornerRadius: 4))
                } else {
                    Label("Image", systemImage: "photo")
                }
            case .files:
                if let imageURL, let image = NSImage(contentsOf: imageURL) {
                    // A copied picture (for example from Photos): show the picture, not the file name.
                    Image(nsImage: image)
                        .resizable()
                        .scaledToFit()
                        .frame(maxHeight: 80, alignment: .leading)
                        .clipShape(RoundedRectangle(cornerRadius: 4))
                } else {
                    Label(item.menuTitle, systemImage: "doc.on.doc")
                        .lineLimit(2)
                        .font(.system(size: 13))
                }
            }
            Text(details)
                .font(.caption2)
                .foregroundStyle(.secondary)
        }
    }

    private var details: String {
        let time = item.date.formatted(.relative(presentation: .named))
        if let app = item.sourceApp { return "\(app) · \(time)" }
        return time
    }
}

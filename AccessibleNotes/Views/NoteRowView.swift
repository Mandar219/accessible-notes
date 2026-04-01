import SwiftUI

struct NoteRowView: View {
    let note: Note
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text(note.title)
                    .font(.headline)
                
                if note.isPinned {
                    Image(systemName: "pin.fill")
                        .foregroundColor(.blue)
                        .accessibilityHidden(true)
                }
            }
            
            if !note.content.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                Text(note.content)
                    .font(.subheadline)
                    .foregroundStyle(.primary)
                    .opacity(0.8)
                    .lineLimit(2)
            }
        }
        .padding(.vertical, 4)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(accessibiltyRowLabel)
        .accessibilityHint("Open note details")
    }
    
    private var accessibiltyRowLabel: String {
        var parts: [String] = [note.title]
        
        if note.isPinned {
            parts.append("Pinned")
        }
        
        return parts.joined(separator: ", ")
    }
}

#Preview {
    NoteRowView(
        note: Note(
            id: UUID(),
            title: "Sample Note",
            content: "This is a sample",
            createdAt: .now,
            updatedAt: .now,
            isPinned: true
        )
    )
}

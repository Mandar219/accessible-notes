//
//  NoteRowView.swift
//  AccessibleNotes
//
//  Created by Mandar Gondane on 3/27/26.
//

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
            
            Text(note.content)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .lineLimit(2)
        }
        .padding(.vertical, 4)
        .accessibilityElement(children: .combine)
        .accessibilityLabel(note.title)
        .accessibilityValue(note.isPinned ? "Pinned" : "Not pinned")
        .accessibilityHint("Open note details")
    }
}

#Preview {
    NoteRowView(
        note: Note(
            id: UUID(),
            title: "Sample Note",
            content: "This is a preview note.",
            createdAt: .now,
            updatedAt: .now,
            isPinned: false
        )
    )
}

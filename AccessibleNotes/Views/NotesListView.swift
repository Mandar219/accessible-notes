//
//  NotesListView.swift
//  AccessibleNotes
//
//  Created by Mandar Gondane on 3/27/26.
//

import SwiftUI

struct NotesListView: View {
    let sampleNotes: [Note] = [
        Note(
            id: UUID(),
            title: "Grocery List",
            content: "Buy milk, eggs, and bread.",
            createdAt: .now,
            updatedAt: .now,
            isPinned: true
        ),
        Note(
            id: UUID(),
            title: "Meeting Notes",
            content: "Discuss accessibility features",
            createdAt: .now,
            updatedAt: .now,
            isPinned: false
        )
    ]
    
    var body: some View {
        NavigationStack {
            List(sampleNotes) { note in
                VStack(alignment: .leading, spacing: 6) {
                    Text(note.title)
                        .font(.headline)
                    
                    Text(note.content)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .lineLimit(2)
                }
                .padding(.vertical, 4)
                .accessibilityElement(children: .combine)
                .accessibilityLabel(note.title)
                .accessibilityValue(note.isPinned ? "Pinned" : "Not Pinned")
                .accessibilityHint("Open note to view details")
            }
            .navigationTitle("Notes")
        }
    }
}

#Preview {
    NotesListView()
}

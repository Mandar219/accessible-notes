//
//  NotesListView.swift
//  AccessibleNotes
//
//  Created by Mandar Gondane on 3/27/26.
//

import SwiftUI

struct NotesListView: View {
    @State private var notes: [Note] = [
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
    
    @State private var isShowingNewNoteSheet: Bool = false
    
    var body: some View {
        NavigationStack {
            List(notes) { note in
                NoteRowView(note: note)
            }
            .navigationTitle("Notes")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        isShowingNewNoteSheet = true
                    } label: {
                        Label("New Note", systemImage: "plus")
                    }
                    .accessibilityLabel("Create a new note")
                    .accessibilityHint("Opens the note editor")
                }
            }
            .sheet(isPresented: $isShowingNewNoteSheet) {
                NoteEditorView { newNote in
                    notes.insert(newNote, at: 0)
                }
            }
        }
    }
}

#Preview {
    NotesListView()
}

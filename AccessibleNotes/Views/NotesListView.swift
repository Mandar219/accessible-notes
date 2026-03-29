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
    @State private var noteToDelete: Note? = nil
    @State private var isShowingDeleteConfirmation: Bool = false
    @State private var searchText: String = ""
    
    var body: some View {
        NavigationStack {
            Group {
                if filteredNotes.isEmpty {
                    emptyStateView
                } else {
                    notesListView
                }
            }
            .navigationTitle("Notes")
            .searchable(text: $searchText, prompt: "Search Notes")
            .toolbar {
                addNoteButton
            }
            .sheet(isPresented: $isShowingNewNoteSheet) {
                newNoteEditorSheet
            }
            .confirmationDialog(
                deleteDialogTitle,
                isPresented: $isShowingDeleteConfirmation,
                titleVisibility: .visible
            ) {
                Button("Delete", role: .destructive) {
                    deleteSelectedNote()
                }

                Button("Cancel", role: .cancel) {
                    noteToDelete = nil
                }
            } message: {
                Text("This action cannot be undone.")
            }
            .onChange(of: isShowingDeleteConfirmation) { oldValue, newValue in
                if oldValue != newValue, newValue == false {
                    noteToDelete = nil
                }
            }
        }
    }
    
    private var notesListView: some View {
        List {
            ForEach(filteredNotes) { note in
                if let index = indexForNote(note) {
                    NavigationLink {
                        NoteDetailView(note: $notes[index])
                    } label: {
                        NoteRowView(note: notes[index])
                    }
                    .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                        Button {
                            promptDelete(for: notes[index])
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }
                        .tint(.red)
                    }
                }
            }
        }
    }
    
    private var emptyStateView: some View {
        ContentUnavailableView(
            "No Notes Found",
            systemImage: "magnifyingglass",
            description: Text("Try searching for a different note or creating a new one.")
        )
    }
    
    @ToolbarContentBuilder private var addNoteButton: some ToolbarContent {
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
    
    private var newNoteEditorSheet: some View {
        NoteEditorView(
            title: "",
            content: "",
            isPinned: false,
            mode: .create
        ) { title, content, isPinned in
            createNote(title: title, content: content, isPinned: isPinned)
        }
    }
    
    private var deleteDialogTitle: String {
        return "Delete \(noteToDelete?.title ?? "this note") note?"
    }
    
    private func indexForNote(_ note: Note) -> Int? {
        return notes.firstIndex(where: { $0.id == note.id })
    }
    
    private var filteredNotes: [Note] {
        let finalSearchText = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if finalSearchText.isEmpty {
            return notes
        }
        
        return notes.filter { note in
            note.title.localizedCaseInsensitiveContains(finalSearchText) || note.content.localizedCaseInsensitiveContains(finalSearchText)
        }
    }
    
    private func createNote(title: String, content: String, isPinned: Bool) {
        let trimmedTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)
        let finalTitle = trimmedTitle.isEmpty ? "Untitled Note" : trimmedTitle
        
        let newNote = Note(
            id: UUID(),
            title: finalTitle,
            content: content,
            createdAt: .now,
            updatedAt: .now,
            isPinned: isPinned
        )
        
        notes.insert(newNote, at: 0)
    }
    
    private func promptDelete(for note: Note) {
        noteToDelete = note
        isShowingDeleteConfirmation = true
    }
    
    private func deleteSelectedNote() {
        guard let selectedNote = noteToDelete else { return }
        notes.removeAll(where: { $0.id == selectedNote.id })
        noteToDelete = nil
    }
}

#Preview {
    NotesListView()
}

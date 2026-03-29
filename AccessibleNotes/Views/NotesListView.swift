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
                    ContentUnavailableView(
                        "No Notes Found",
                        systemImage: "magnifyingglass",
                        description: Text("Try searching for a different note or creating a new one.")
                    )
                } else {
                    List {
                        ForEach(filteredNotes) { note in
                            if let index = notes.firstIndex(where: { $0.id == note.id }) {
                                NavigationLink {
                                    NoteDetailView(note: $notes[index])
                                } label: {
                                    NoteRowView(note: notes[index])
                                }
                                .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                                    Button {
                                        noteToDelete = notes[index]
                                        isShowingDeleteConfirmation = true
                                    } label: {
                                        Label("Delete", systemImage: "trash")
                                    }
                                    .tint(.red)
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("Notes")
            .searchable(text: $searchText, prompt: "Search Notes")
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
                NoteEditorView(
                    title: "",
                    content: "",
                    isPinned: false,
                    mode: .create
                ) { title, content, isPinned in
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
            }
            .confirmationDialog(
                "Delete \(noteToDelete?.title ?? "this note") note?",
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
    
    private var filteredNotes: [Note] {
        let finalSearchText = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if finalSearchText.isEmpty {
            return notes
        }
        
        return notes.filter { note in
            note.title.localizedCaseInsensitiveContains(finalSearchText) || note.content.localizedCaseInsensitiveContains(finalSearchText)
        }
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

import SwiftUI

struct NotesListView: View {
    @StateObject private var viewModel: NotesViewModel = NotesViewModel()
    
    @State private var isShowingNewNoteSheet: Bool = false
    @State private var noteToDelete: Note? = nil
    @State private var isShowingDeleteConfirmation: Bool = false
    
    var body: some View {
        NavigationStack {
            Group {
                if viewModel.filteredNotes.isEmpty {
                    emptyStateView
                } else {
                    notesListView
                }
            }
            .navigationTitle("Notes")
            .searchable(text: $viewModel.searchText, prompt: "Search Notes")
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
            ForEach(viewModel.filteredNotes) { note in
                if let index = viewModel.indexForNote(note) {
                    NavigationLink {
                        NoteDetailView(
                            note: $viewModel.notes[index],
                            onSaveEdits: { title, content in
                                viewModel.updateNote(id: note.id, title: title, content: content)
                            },
                            onDelete: {
                                viewModel.deleteNote(note)
                            },
                            onTogglePin: {
                                viewModel.togglePin(for: note)
                            }
                        )
                    } label: {
                        NoteRowView(note: viewModel.notes[index])
                    }
                    .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                            Button {
                                promptDelete(for: viewModel.notes[index])
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                            .tint(.red)
                            .accessibilityLabel("Delete")
                            .accessibilityHint("Asks you to confirm deletion of the note")
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
            mode: .create
        ) { title, content in
            viewModel.createNote(title: title, content: content)
            AccessibilityService.announce("Note saved")
        }
    }
    
    private var deleteDialogTitle: String {
        return "Delete \(noteToDelete?.title ?? "this note") note?"
    }
    
    private func promptDelete(for note: Note) {
        noteToDelete = note
        isShowingDeleteConfirmation = true
    }
    
    private func deleteSelectedNote() {
        guard let selectedNote = noteToDelete else { return }
        viewModel.deleteNote(selectedNote)
        noteToDelete = nil
        AccessibilityService.announce("Note deleted")
    }
}

#Preview {
    NotesListView()
}

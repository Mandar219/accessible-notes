//
//  NoteEditorView.swift
//  AccessibleNotes
//
//  Created by Mandar Gondane on 3/27/26.
//

import SwiftUI

struct NoteEditorView: View {
    @Environment(\.dismiss) private var dismiss
    
    @State private var title: String = ""
    @State private var content: String = ""
    @State private var isPinned: Bool = false
    
    let onSave: (Note) -> Void
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Note Details") {
                    TextField("Title", text: $title)
                        .accessibilityLabel("Title")
                        .accessibilityHint("Enter the title of your Note")
                    
                    TextEditor(text: $content)
                        .frame(minHeight: 200)
                        .accessibilityLabel("Content")
                        .accessibilityHint("Enter the content of your note")
                    
                    Toggle("Pinned", isOn: $isPinned)
                        .accessibilityHint("Marks this note as pinned")
                }
            }
            .navigationTitle("New Note")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
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
                        
                        onSave(newNote)
                        dismiss()
                    }
                    .tint(.blue)
                    .disabled(content.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty && title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                    .accessibilityHint("Saves the note and returns to the notes list")
                }
            }
        }
    }
}

#Preview {
    NoteEditorView { _ in }
}

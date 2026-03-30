//
//  NoteDetailView.swift
//  AccessibleNotes
//
//  Created by Mandar Gondane on 3/28/26.
//

import SwiftUI

struct NoteDetailView : View {
    @Binding var note: Note
    @State private var isShowingEditSheet: Bool = false
    @State private var isShowingDeleteConfirmation: Bool = false
    @Environment(\.dismiss) private var dismiss
    
    let onSaveEdits: (String, String) -> Void
    let onDelete: () -> Void
    let onTogglePin: () -> Void
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                HStack(alignment: .top, spacing: 8) {
                    Text(note.title)
                        .font(.title)
                        .fontWeight(.semibold)
                        .accessibilityAddTraits(.isHeader)
                }
                
                Text("Last updated \(note.updatedAt.formatted(date: .abbreviated, time: .shortened))")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                
                Divider()
                
                Text(note.content.isEmpty ? "No content" : note.content)
                    .font(.body)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding()
        }
        .navigationTitle("Note")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Edit") {
                    isShowingEditSheet = true
                }
                .accessibilityHint("Opens the note editor")
            }
            
            ToolbarItemGroup(placement: .bottomBar) {
                Button {
                    isShowingDeleteConfirmation = true
                } label: {
                    Label("Delete", systemImage: "trash")
                }
                .tint(.red)
                
                Spacer()
                
                Button {
                    onTogglePin()
                } label: {
                    Label(note.isPinned ? "Unpin" : "Pin", systemImage: note.isPinned ? "pin.fill" : "pin")
                }
                .tint(note.isPinned ? .blue : nil)
                .accessibilityHint(note.isPinned ? "Removes this note from pinned notes" : "Pins this note")
            }
        }
        .sheet(isPresented: $isShowingEditSheet) {
            NoteEditorView(
                title: note.title,
                content: note.content,
                mode: .edit
            ) { updateTitle, updatedContent in
                onSaveEdits(updateTitle, updatedContent)
            }
        }
        .confirmationDialog(
            "Delete \"\(note.title)\"?",
            isPresented: $isShowingDeleteConfirmation,
            titleVisibility: .visible
        ) {
            Button(role: .destructive) {
                onDelete()
                dismiss()
            }
        } message: {
            Text("This action cannot be undone.")
        }
    }
}

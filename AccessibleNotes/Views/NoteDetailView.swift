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
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                HStack(alignment: .top, spacing: 8) {
                    Text(note.title)
                        .font(.title)
                        .fontWeight(.semibold)
                        .accessibilityAddTraits(.isHeader)
                    
                    if note.isPinned {
                        Image(systemName: "pin.fill")
                            .foregroundColor(.blue)
                            .accessibilityLabel("Pinned")
                    }
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
        }
        .sheet(isPresented: $isShowingEditSheet) {
            NoteEditorView(
                title: note.title,
                content: note.content,
                isPinned: note.isPinned,
                mode: .edit
            ) { updateTitle, updatedContent, updatedPinned in
                let trimmedTitle = updateTitle.trimmingCharacters(in: .whitespacesAndNewlines)
                note.title = trimmedTitle.isEmpty ? "Untitled Note" : trimmedTitle
                note.content = updatedContent
                note.isPinned = updatedPinned
                note.updatedAt = .now
            }
        }
    }
}

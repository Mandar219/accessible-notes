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
                        .accessibilityLabel("Note title")
                        .accessibilityValue(note.title)
                        
                }
                
                Text("Last updated \(note.updatedAt.formatted(date: .abbreviated, time: .shortened))")
                    .font(.subheadline)
                    .foregroundStyle(.primary)
                    .opacity(0.7)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .fixedSize(horizontal: false, vertical: true)
                    .accessibilityLabel("Last updated \(note.updatedAt.formatted(date: .complete, time: .shortened))")
                
                Divider()
                    .overlay(Color.primary.opacity(0.4))
                
                Text(note.content.isEmpty ? "No content" : note.content)
                    .font(.body)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .accessibilityLabel("Content")
                    .accessibilityValue(note.content.isEmpty ? "No content" : note.content)
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
        .safeAreaInset(edge: .bottom) {
            HStack {
                Button {
                    isShowingDeleteConfirmation = true
                } label: {
                    Label("Delete", systemImage: "trash")
                        .frame(maxWidth: .infinity)
                }
                .tint(Color(.systemRed))
                .accessibilityHint("Asks you to confirm deletion of the note")
                
                Spacer()
                
                Button {
                    let wasPinned = note.isPinned
                    onTogglePin()
                    AccessibilityService.announce(wasPinned ? "Note unpinned" : "Note pinned")
                } label: {
                    Label(note.isPinned ? "Unpin" : "Pin", systemImage: note.isPinned ? "pin.fill" : "pin")
                        .frame(maxWidth: .infinity)
                }
                .tint(note.isPinned ? Color(.systemBlue) : nil)
                .accessibilityHint(note.isPinned ? "Removes this note from pinned notes" : "Pins this note")
            }
            .padding()
            .background(.ultraThinMaterial)
            .overlay(
                Rectangle()
                    .frame(height: 2)
                    .foregroundStyle(.primary.opacity(0.5)),
                alignment: .top
            )
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


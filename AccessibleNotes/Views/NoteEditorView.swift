//
//  NoteEditorView.swift
//  AccessibleNotes
//
//  Created by Mandar Gondane on 3/27/26.
//

import SwiftUI

struct NoteEditorView: View {
    enum Mode {
        case create
        case edit
    }
    
    @Environment(\.dismiss) private var dismiss
    
    @State private var title: String = ""
    @State private var content: String = ""
    @State private var isPinned: Bool = false
    
    let mode: Mode
    let onSave: (String, String, Bool) -> Void
    
    init(
        title: String,
        content: String,
        isPinned: Bool,
        mode: Mode,
        onSave: @escaping (String, String, Bool) -> Void
    ) {
        _title = State(initialValue: title)
        _content = State(initialValue: content)
        _isPinned = State(initialValue: isPinned)
        self.mode = mode
        self.onSave = onSave
    }
    
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
            .navigationTitle(mode == .create ? "New Note" : "Edit Note")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button(mode == .create ? "Save" : "Done") {
                        onSave(title, content, isPinned)
                        dismiss()
                    }
                    .tint(.blue)
                    .disabled(isSaveDisabled)
                    .accessibilityHint(
                        mode == .create
                        ? "Saves the note and returns to the notes list"
                        : "Saves your changes and returns to the note"
                    )
                }
            }
        }
    }
    
    private var isSaveDisabled: Bool {
        title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty && content.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
}

#Preview("Create") {
    NoteEditorView(title: "", content: "", isPinned: false, mode: .create) { _, _, _ in }
}

#Preview("Edit") {
    NoteEditorView(title: "Test", content: "Exisiting note", isPinned: true, mode: .edit) { _, _, _ in }
}

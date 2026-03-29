//
//  NotesViewModel.swift
//  AccessibleNotes
//
//  Created by Mandar Gondane on 3/29/26.
//

import Foundation
import Combine

final class NotesViewModel: ObservableObject {
    @Published var notes: [Note] = [
        Note(
            id: UUID(),
            title: "Grocery List",
            content: "Buy milk, eggs, bread",
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
    
    @Published var searchText = ""
    
    var filteredNotes: [Note] {
        let finalSearchText = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !finalSearchText.isEmpty else {
            return notes
        }
        
        return notes.filter { note in
            note.title.localizedCaseInsensitiveContains(finalSearchText) || note.content.localizedCaseInsensitiveContains(finalSearchText)
        }
    }
    
    func createNote(title: String, content: String, isPinned: Bool) {
        let finalTitle = getFinalTitle(title)
        
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
    
    func deleteNote(_ note: Note) {
        notes.removeAll(where: { $0.id == note.id })
    }

    func updateNote(id: UUID, title: String, content: String, isPinned: Bool) {
        guard let index = notes.firstIndex(where: { $0.id == id }) else { return }

        let finalTitle = getFinalTitle(title)

        notes[index].title = finalTitle
        notes[index].content = content
        notes[index].isPinned = isPinned
        notes[index].updatedAt = .now
    }

    func indexForNote(_ note: Note) -> Int? {
        notes.firstIndex { $0.id == note.id }
    }
    
    private func getFinalTitle(_ title: String) -> String {
        let trimmedTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmedTitle.isEmpty ? "Untitled Note" : trimmedTitle
    }
}

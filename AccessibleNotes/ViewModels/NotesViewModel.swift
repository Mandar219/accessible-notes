import Foundation
import Combine

final class NotesViewModel: ObservableObject {
    @Published var notes: [Note] = []
    @Published var searchText = ""
    
    private let storageService: StorageService = StorageService()
    
    init () {
        loadNotes()
    }
    
    var filteredNotes: [Note] {
        let finalSearchText = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        let baseNotes: [Note]
        
        if finalSearchText.isEmpty {
            baseNotes = notes
        } else {
            baseNotes = notes.filter { note in
                note.title.localizedCaseInsensitiveContains(finalSearchText) || note.content.localizedCaseInsensitiveContains(finalSearchText)
            }
        }
        
        return baseNotes.sorted { lhs, rhs in
            if lhs.isPinned != rhs.isPinned {
                return lhs.isPinned && !rhs.isPinned
            }
            
            return lhs.updatedAt > rhs.updatedAt
        }
    }
    
    func createNote(title: String, content: String) {
        let finalTitle = getFinalTitle(title)
        
        let newNote = Note(
            id: UUID(),
            title: finalTitle,
            content: content,
            createdAt: .now,
            updatedAt: .now,
            isPinned: false
        )
        
        notes.insert(newNote, at: 0)
        saveNotes()
    }
    
    func deleteNote(_ note: Note) {
        notes.removeAll(where: { $0.id == note.id })
        saveNotes()
    }

    func updateNote(id: UUID, title: String, content: String) {
        guard let index = notes.firstIndex(where: { $0.id == id }) else { return }

        let finalTitle = getFinalTitle(title)

        notes[index].title = finalTitle
        notes[index].content = content
        notes[index].updatedAt = .now
        saveNotes()
    }

    func indexForNote(_ note: Note) -> Int? {
        notes.firstIndex { $0.id == note.id }
    }
    
    func togglePin(for note: Note) {
        guard let index = notes.firstIndex(where: { $0.id == note.id }) else { return }
        
        notes[index].isPinned.toggle()
        notes[index].updatedAt = .now
        saveNotes()
    }
    
    private func getFinalTitle(_ title: String) -> String {
        let trimmedTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmedTitle.isEmpty ? "Untitled Note" : trimmedTitle
    }
    
    private func saveNotes() {
        storageService.saveNotes(notes)
    }
    
    private func loadNotes() {
        notes = storageService.loadNotes()
    }
}

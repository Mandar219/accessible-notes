//
//  StorageService.swift
//  AccessibleNotes
//
//  Created by Mandar Gondane on 3/29/26.
//

import Foundation

struct StorageService {
    private let notesKey = "saved_notes"
    
    func saveNotes(_ notes: [Note]) {
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(notes)
            UserDefaults.standard.set(data, forKey: notesKey)
        } catch {
            print("Failed to save notes: \(error)")
        }
    }
    
    func loadNotes() -> [Note] {
        guard let data = UserDefaults.standard.data(forKey: notesKey) else {
            return []
        }
        
        do {
            let decoder = JSONDecoder()
            return try decoder.decode([Note].self, from: data)
        } catch {
            print("Failed to load notes: \(error)")
            return []
        }
    }
}

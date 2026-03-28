//
//  Note.swift
//  AccessibleNotes
//
//  Created by Mandar Gondane on 3/27/26.
//

import Foundation

struct Note : Identifiable, Codable {
    let id: UUID
    var title: String
    var content: String
    var createdAt: Date
    var updatedAt: Date
    var isPinned: Bool
}

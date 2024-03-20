//
//  Previewer.swift
//  Noted
//
//  Created by Julia Gurbanova on 20.03.2024.
//

import Foundation
import SwiftData

@MainActor
struct Previewer {
    let container: ModelContainer
    let note: Note

    init() throws {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        container = try ModelContainer(for: Note.self, configurations: config)

        note = Note(content: "Sample Note", date: .now)

        container.mainContext.insert(note)
    }
}

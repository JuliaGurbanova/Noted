//
//  SearchResultsView.swift
//  Noted
//
//  Created by Julia Gurbanova on 20.03.2024.
//

import SwiftData
import SwiftUI

struct SearchResultsView: View {
    @Environment(\.modelContext) private var context
    @Query private var notes: [Note]
    var allFolders: [Folder]

    init(searchText: String = "", allFolders: [Folder]) {
        self.allFolders = allFolders

        _notes = Query(filter: #Predicate { note in
            if searchText.isEmpty {
                true
            } else {
                note.content.localizedStandardContains(searchText)
            }
        }, sort: [], animation: .smooth)
    }

    var body: some View {
        List {
            ForEach(notes) { note in
                NavigationLink(destination: NoteDetailView(note: note)) {
                    NoteRowView(note: note)
                }
                .contextMenu {
                    NoteContextMenuView(note: note, allFolders: allFolders)
                }
            }
            .onDelete(perform: deleteNote)
        }
    }

    func deleteNote(at offsets: IndexSet) {
        for offset in offsets {
            let note = notes[offset]
            context.delete(note)
        }
    }
}

#Preview {
    SearchResultsView(allFolders: [Folder]())
}

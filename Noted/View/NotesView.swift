//
//  NotesView.swift
//  Noted
//
//  Created by Julia Gurbanova on 17.03.2024.
//

import SwiftUI
import SwiftData

struct NotesView: View {
    @Environment(\.modelContext) private var context
    @Query private var notes: [Note]
    var folder: String?
    var allFolders: [Folder]
    @State private var isShowingPinned = false
    @State private var isShowingPinnedContent = true

    init(folder: String?, allFolders: [Folder]) {
        self.folder = folder
        self.allFolders = allFolders

        let selectedAllNotes = (folder == "All Notes")
        let selectedFavorites = (folder == "Favorites")

        let predicate = #Predicate<Note> {
            return $0.folder?.folderTitle == folder
        }
        let favoritePredicate = #Predicate<Note> {
            return $0.isFavorite
        }

        let finalPredicate = selectedAllNotes ? nil : (selectedFavorites ? favoritePredicate : predicate)

        _notes = Query(filter: finalPredicate, sort: [], animation: .smooth)
    }

    var body: some View {
        List {
            Section(isExpanded: $isShowingPinnedContent) {
                ForEach(notes) { note in
                    if note.isPinned {
                        NavigationLink(destination: NoteDetailView(note: note)) {
                            NoteRowView(note: note)
                        }
                        .contextMenu {
                            NoteContextMenuView(note: note, allFolders: allFolders)
                        }
                    }
                }
                .onDelete(perform: deleteNote)
            } header: {
                Label("Pinned", systemImage: isShowingPinnedContent ? "chevron.down" : "chevron.right")
                    .onTapGesture {
                        withAnimation {
                            isShowingPinnedContent.toggle()
                        }
                    }
            }

            Section() {
                ForEach(notes) { note in
                    if !note.isPinned {
                        NavigationLink(destination: NoteDetailView(note: note)) {
                            NoteRowView(note: note)
                        }
                        .contextMenu {
                            NoteContextMenuView(note: note, allFolders: allFolders)
                        }
                    }
                }
                .onDelete(perform: deleteNote)
            } header: {
                Text("All")
            }
        }
    }

    func deleteNote(at offsets: IndexSet) {
        for offset in offsets {
            let note = notes[offset]
            context.delete(note)
        }
    }
}



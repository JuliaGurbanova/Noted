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
    @Query var notes: [Note]
    var folder: Folder?
    var folderString: String?
    var allFolders: [Folder]
    @State private var isShowingPinnedContent = true

    init(searchText: String = "", folder: Folder? = nil, folderString: String?, allFolders: [Folder]) {
        self.folder = folder
        self.folderString = folderString
        self.allFolders = allFolders

        let selectedAllNotes = (folderString == "All Notes")
        let selectedFavorites = (folderString == "Favorites")

        let predicate = #Predicate<Note> {
            return $0.folder?.folderTitle == folderString
        }
        let favoritePredicate = #Predicate<Note> {
            return $0.isFavorite
        }

        let searchPredicate = #Predicate<Note> {
            return $0.content.localizedStandardContains(searchText)
        }
        let finalPredicate = selectedAllNotes ? nil : (selectedFavorites ? favoritePredicate : predicate)

        _notes = Query(filter: searchText.isEmpty ? finalPredicate : searchPredicate, sort: [SortDescriptor(\Note.date, order: .reverse)], animation: .smooth)
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
        .toolbar {
            Button("Add Note", systemImage: "square.and.pencil", action: addNote)
        }
    }
    
    func addNote() {
        let note = Note(content: "", folder: folder,date: .now)
        if folderString == "Favorites" {
            note.isFavorite = true
        }
        context.insert(note)
    }

    func deleteNote(at offsets: IndexSet) {
        for offset in offsets {
            let note = notes[offset]
            context.delete(note)
        }
    }
}

#Preview {
    do {
        let previewer = try Previewer()

        return NotesView(folderString: "All Notes", allFolders: [Folder]())
            .modelContainer(previewer.container)
    } catch {
        return Text("Failed to create preview: \(error.localizedDescription)")
    }
}


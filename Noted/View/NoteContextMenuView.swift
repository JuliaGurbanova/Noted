//
//  NoteContextMenuView.swift
//  Noted
//
//  Created by Julia Gurbanova on 18.03.2024.
//

import SwiftUI

struct NoteContextMenuView: View {
    @Environment(\.modelContext) private var context
    var note: Note
    var allFolders: [Folder]

    var body: some View {
        VStack {
            Button {
                note.isPinned.toggle()
            } label: {
                if note.isPinned {
                    Label("Unpin Note", systemImage: "pin.slash")
                } else {
                    Label("Pin Note", systemImage: "pin")
                }
            }

            Button {
                note.isFavorite.toggle()
            } label: {
                if note.isFavorite {
                    Label("Unfavorite", systemImage: "star.slash")
                } else {
                    Label("Favorite", systemImage: "star")
                }
            }

            Menu {
                ForEach(allFolders) { folder in
                    Button {
                        note.folder = folder
                    } label: {
                        HStack {
                            if folder == note.folder {
                                Image(systemName: "checkmark")
                                    .font(.caption)
                            }
                            Text(folder.folderTitle)
                        }
                    }
                }

                Button("Remove from Folder", role: .destructive) {
                    note.folder = nil
                }
            } label: {
                Label("Folders", systemImage: "folder")
            }

            Button("Delete", systemImage: "trash", role: .destructive) {
                context.delete(note)
            }
        }
    }
}

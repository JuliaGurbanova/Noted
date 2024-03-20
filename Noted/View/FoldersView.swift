//
//  FoldersView.swift
//  Noted
//
//  Created by Julia Gurbanova on 20.03.2024.
//

import SwiftData
import SwiftUI

struct FoldersView: View {
    @Environment(\.modelContext) private var context
    var folders: [Folder]
    var notes: [Note]

    @State private var searchText = ""
    @State private var addFolder = false
    @State private var folderTitle = ""
    @State private var selectedFolder: Folder?
    @State private var renameRequest = false

    var body: some View {
        List {
            NavigationLink(destination: NotesView(folderString: "All Notes", allFolders: folders)) {
                HStack {
                    Text("All Notes")
                    Spacer()
                    Text("\(notes.count)")
                        .foregroundStyle(.secondary)
                }
            }

            NavigationLink(destination: NotesView(folderString: "Favorites", allFolders: folders)) {
                Text("Favorites")
            }

            Section {
                ForEach(folders) { folder in
                    NavigationLink(destination: NotesView(folder: folder, folderString: folder.folderTitle, allFolders: folders)) {
                        Text(folder.folderTitle)
                    }
                        .contextMenu {
                            Button("Rename") {
                                folderTitle = folder.folderTitle
                                selectedFolder = folder
                                renameRequest = true
                            }

                            Button("Delete", role: .destructive) {
                                if let selectedFolder {
                                    context.delete(selectedFolder)
                                    folderTitle = ""
                                    self.selectedFolder = nil
                                }
                            }
                        }
                }
                .onDelete(perform: deleteFolder)
            } header: {
                Text("My Folders")
                    .bold()
                    .font(.headline)
            }
        }
        .navigationTitle("Folders")
        .toolbar {
            ToolbarItemGroup(placement: .bottomBar) {
                Button("", systemImage: "folder.badge.plus") {
                    addFolder.toggle()
                }
                Spacer()

                NavigationLink {
                    NoteDetailView()
                } label: {
                    Label("", systemImage: "square.and.pencil")
                }
            }
        }
        .alert("Add Folder", isPresented: $addFolder) {
            TextField("Enter title", text: $folderTitle)
            Button("Cancel", role: .cancel) {
                folderTitle = ""
            }
            Button("Add") {
                let folder = Folder(folderTitle: folderTitle)
                context.insert(folder)
                folderTitle = ""
            }
        }
        .alert("Rename Folder", isPresented: $renameRequest) {
            TextField("Enter new title", text: $folderTitle)
            Button("Cancel", role: .cancel) {
                folderTitle = ""
                selectedFolder = nil
            }
            Button("Rename") {
                if let selectedFolder {
                    selectedFolder.folderTitle = folderTitle
                    folderTitle = ""
                    self.selectedFolder = nil
                }
            }
        }
        .onAppear {
            if notes.isEmpty {
                let starterNote = Note(title: "Hello!", content: "This is a sample note. Feel free to edit or delete it.", date: Date.now)
                context.insert(starterNote)
            }
        }
    }

    func deleteFolder(at offsets: IndexSet) {
        for offset in offsets {
            let folder = folders[offset]
            context.delete(folder)
        }
    }
}

#Preview {
    do {
        let previewer = try Previewer()

        return FoldersView(folders: [Folder](), notes: [Note]())
            .modelContainer(previewer.container)
    } catch {
        return Text("Failed to create preview: \(error.localizedDescription)")
    }
}

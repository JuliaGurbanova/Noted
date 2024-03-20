//
//  ContentView.swift
//  Noted
//
//  Created by Julia Gurbanova on 17.03.2024.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var context
    @Query var folders: [Folder]
    @Query var notes: [Note]

    @State private var searchText = ""

    var body: some View {
        NavigationStack {
            if !searchText.isEmpty {
                SearchResultsView(searchText: searchText, allFolders: folders)
            } else {
                FoldersView(folders: folders, notes: notes)
            }
        }
        .searchable(text: $searchText)
    }
}

#Preview {
    do {
        let previewer = try Previewer()

        return ContentView()
            .modelContainer(previewer.container)
    } catch {
        return Text("Failed to create preview: \(error.localizedDescription)")
    }
}

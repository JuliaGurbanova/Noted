//
//  NoteDetailView.swift
//  Noted
//
//  Created by Julia Gurbanova on 17.03.2024.
//

import SwiftUI
import SwiftData

struct NoteDetailView: View {
    @Environment(\.modelContext) private var context
    @Bindable var note: Note
    @State private var isEditing = false
    @FocusState private var isFocused: Bool

    init(folder: Folder? = nil) {
        self.note = Note(content: "", folder: folder, date: Date.now)
        isFocused = true
    }

    init(note: Note, isFocused: Bool = false) {
        self.note = note
    }

    var body: some View {
        VStack {
            TextEditor(text: $note.content)
                .padding(.horizontal, 16)
                .focused($isFocused)
        }
        .toolbar {
            ToolbarItemGroup(placement: .topBarTrailing) {
                ShareLink(item: note.content)

                if isEditing {
                    Button("Done") {
                        isEditing = false
                        isFocused = false
                    }
                }
            }
        }
        .onAppear {
            if note.content.isEmpty {
                isEditing = true
                isFocused = true
            }
        }
        .onTapGesture {
            isEditing = true
            isFocused = true
        }
        .onChange(of: note.content) {
            if let firstLine = note.content.components(separatedBy: "\n").first {
                note.title = firstLine
            }
            note.date = .now
            context.insert(note)
        }
    }
}


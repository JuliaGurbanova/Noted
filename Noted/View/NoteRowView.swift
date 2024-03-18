//
//  NoteRowView.swift
//  Noted
//
//  Created by Julia Gurbanova on 17.03.2024.
//

import SwiftUI

struct NoteRowView: View {
    var note: Note
    var body: some View {
        VStack(alignment: .leading) {
            Text(note.title)
                .font(.headline)
                .fontWeight(.bold)
                .lineLimit(1)
                .truncationMode(.tail)
            Text(note.date.formatted())
                .font(.subheadline)
        }
    }
}


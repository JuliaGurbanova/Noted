//
//  Note.swift
//  Noted
//
//  Created by Julia Gurbanova on 17.03.2024.
//

import Foundation
import SwiftData

@Model
class Note {
    var title: String
    var content: String
    var date: Date
    var folder: Folder?
    var isFavorite = false
    var isPinned = false

    init(title: String = "New Note", content: String, folder: Folder? = nil, date: Date) {
        self.title = title
        self.content = content
        self.folder = folder
        self.date = date
    }

}

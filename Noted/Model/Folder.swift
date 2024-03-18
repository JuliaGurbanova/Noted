//
//  Folder.swift
//  Noted
//
//  Created by Julia Gurbanova on 17.03.2024.
//

import Foundation
import SwiftData

@Model
class Folder {
    var folderTitle: String

    @Relationship(deleteRule: .nullify, inverse: \Note.folder)
    var notes: [Note]?

    init(folderTitle: String) {
        self.folderTitle = folderTitle
    }
}

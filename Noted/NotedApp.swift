//
//  NotedApp.swift
//  Noted
//
//  Created by Julia Gurbanova on 17.03.2024.
//

import SwiftUI
import SwiftData

@main
struct NotedApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: [Note.self, Folder.self])
    }
}

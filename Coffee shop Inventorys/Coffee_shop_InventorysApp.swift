//
//  Coffee_shop_InventorysApp.swift
//  Coffee shop Inventorys
//
//  Created by Dan on 1/10/26.
//

import SwiftUI
import SwiftData

@main
struct Coffee_shop_InventorysApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(sharedModelContainer)
    }
}

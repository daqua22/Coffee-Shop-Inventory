//
//  Coffee_shop_InventorysApp.swift
//  Coffee shop Inventorys
//
//  Created by Dan on 1/10/26.
//

import SwiftUI
import SwiftData

@main
struct CoffeeInventoryApp: App {
    var body: some Scene {
        WindowGroup {
            CategoryListView()
                .modelContainer(for: [Category.self, Subcategory.self, InventoryItem.self])
        }
    }
}

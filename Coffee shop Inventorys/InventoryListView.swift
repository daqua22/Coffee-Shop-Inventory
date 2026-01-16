//
//  InventoryListView.swift
//  Coffee shop Inventorys
//
//  Created by Dan on 1/15/26.
//

import SwiftUI
import SwiftData

struct InventoryListView: View {
    let category: Category
    let subcategory: Subcategory?
    @Environment(\.modelContext) private var context
    @State private var showingAddItem = false
    @State private var showHidden = false
    @State private var selectedItem: InventoryItem?
    
    var visibleItems: [InventoryItem] {
        let filtered = if let subcategory = subcategory {
            subcategory.items.filter { showHidden || !$0.isHidden }
        } else {
            category.items.filter { ($0.subcategory == nil) && (showHidden || !$0.isHidden) }
        }
        return filtered.sorted { $0.name < $1.name }
    }
    
    var body: some View {
        List {
            ForEach(visibleItems) { item in
                ItemRow(item: item)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        selectedItem = item
                    }
            }
        }
        .navigationTitle(subcategory?.name ?? "All Items")
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button {
                    showingAddItem = true
                } label: {
                    Label("Add Item", systemImage: "plus")
                }
            }
            ToolbarItem(placement: .secondaryAction) {
                Button {
                    showHidden.toggle()
                } label: {
                    Label(showHidden ? "Hide Hidden Items" : "Show Hidden Items",
                          systemImage: showHidden ? "eye.slash" : "eye")
                }
            }
        }
        .sheet(isPresented: $showingAddItem) {
            AddItemSheet(category: category, subcategory: subcategory, isPresented: $showingAddItem)
        }
        .sheet(item: $selectedItem) { item in
            ItemDetailView(item: item)
        }
        .overlay {
            if visibleItems.isEmpty {
                ContentUnavailableView(
                    showHidden ? "No Items" : "No Visible Items",
                    systemImage: "cube.box",
                    description: Text(showHidden ? "Tap + to add your first item" : "All items are hidden")
                )
            }
        }
    }
}

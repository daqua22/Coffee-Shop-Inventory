//
//  CategoryListView.swift
//  Coffee shop Inventorys
//
//  Created by Dan on 1/11/26.
//

import SwiftUI
import SwiftData

struct CategoryListView: View {
    @Query(sort: \Category.name) var categories: [Category]
    @Environment(\.modelContext) private var context
    @State private var showingAddCategory = false
    @State private var newCategoryName = ""
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(categories) { category in
                    NavigationLink(destination: CategoryDetailView(category: category)) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(category.name)
                                .font(.headline)
                            HStack {
                                Text("\(category.subcategories.count) locations")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                Text("•")
                                    .foregroundColor(.secondary)
                                Text("\(category.items.filter { !$0.isHidden }.count) items")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                }
                .onDelete(perform: deleteCategories)
            }
            .navigationTitle("Categories")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        showingAddCategory = true
                    } label: {
                        Label("Add Category", systemImage: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddCategory) {
                AddCategorySheet(isPresented: $showingAddCategory)
            }
            .overlay {
                if categories.isEmpty {
                    ContentUnavailableView(
                        "No Categories",
                        systemImage: "folder.badge.plus",
                        description: Text("Tap + to create your first category")
                    )
                }
            }
        }
    }
    
    private func deleteCategories(at offsets: IndexSet) {
        for index in offsets {
            context.delete(categories[index])
        }
        try? context.save()
    }
}

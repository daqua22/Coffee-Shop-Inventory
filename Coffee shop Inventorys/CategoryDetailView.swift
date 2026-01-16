//
//  CategoryDetailView.swift
//  Coffee shop Inventorys
//
//  Created by Dan on 1/15/26.
//

import SwiftUI
import SwiftData

struct CategoryDetailView: View {
    let category: Category
    @Environment(\.modelContext) private var context
    @State private var showingAddSubcategory = false
    
    var sortedSubcategories: [Subcategory] {
        category.subcategories.sorted { $0.name < $1.name }
    }
    
    var body: some View {
        List {
            Section {
                NavigationLink(destination: InventoryListView(category: category, subcategory: nil)) {
                    HStack {
                        Image(systemName: "square.grid.2x2")
                            .foregroundColor(.blue)
                        Text("All Items")
                            .font(.headline)
                        Spacer()
                        Text("\(category.items.filter { !$0.isHidden && $0.subcategory == nil }.count)")
                            .foregroundColor(.secondary)
                    }
                }
            }
            
            if !sortedSubcategories.isEmpty {
                Section("Storage Locations") {
                    ForEach(sortedSubcategories) { subcategory in
                        NavigationLink(destination: InventoryListView(category: category, subcategory: subcategory)) {
                            HStack {
                                Image(systemName: "mappin.circle.fill")
                                    .foregroundColor(.orange)
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(subcategory.name)
                                        .font(.headline)
                                    Text("\(subcategory.items.filter { !$0.isHidden }.count) items")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                            }
                        }
                    }
                    .onDelete(perform: deleteSubcategories)
                }
            }
        }
        .navigationTitle(category.name)
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button {
                    showingAddSubcategory = true
                } label: {
                    Label("Add Location", systemImage: "plus")
                }
            }
        }
        .sheet(isPresented: $showingAddSubcategory) {
            AddSubcategorySheet(category: category, isPresented: $showingAddSubcategory)
        }
    }
    
    private func deleteSubcategories(at offsets: IndexSet) {
        for index in offsets {
            context.delete(sortedSubcategories[index])
        }
        try? context.save()
    }
}

//
//  InventoryListView.swift
//  Coffee shop Inventorys
//
//  Created by Dan on 1/10/26.
//

import SwiftUI
import SwiftData

struct InventoryListView: View {
    @Query(sort: \InventoryItem.name) var items: [InventoryItem]
    @Environment(\.modelContext) private var context

    var body: some View {
        NavigationView {
            List {
                ForEach(items, id: \.id) { item in
                    HStack {
                        Text(item.name)
                        Spacer()
                        Text("\(item.quantity) \(item.unit)")
                            .foregroundColor(item.quantity <= item.minQuantity ? .red : .black)
                        Button("-") {
                            decrease(item: item)
                        }
                        .buttonStyle(BorderlessButtonStyle())
                    }
                }
            }
            .navigationTitle("Inventory")
            .toolbar {
                Button("Add Coffee") {
                    addSampleItem()
                }
            }
        }
    }

    // MARK: - Functions
    private func addSampleItem() {
        let newItem = InventoryItem(name: "Espresso Beans", quantity: 5, unit: "кг", minQuantity: 2)
        context.insert(newItem)
        try? context.save()
    }

    private func decrease(item: InventoryItem) {
        item.quantity = max(0, item.quantity - 1)
        try? context.save()
    }
}

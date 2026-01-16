//
//  AddItemSheet.swift
//  Coffee shop Inventorys
//
//  Created by Dan on 1/15/26.
//

import SwiftUI
import SwiftData

struct AddItemSheet: View {
    let category: Category
    let subcategory: Subcategory?
    @Binding var isPresented: Bool
    @Environment(\.modelContext) private var context
    
    @State private var itemName = ""
    @State private var quantity = ""
    @State private var unit = "kg"
    @State private var parLevel = ""
    @State private var selectedSubcategory: Subcategory?
    
    let commonUnits = ["kg", "g", "L", "ml", "pcs", "bags", "boxes"]
    
    var availableSubcategories: [Subcategory] {
        category.subcategories.sorted { $0.name < $1.name }
    }
    
    init(category: Category, subcategory: Subcategory?, isPresented: Binding<Bool>) {
        self.category = category
        self.subcategory = subcategory
        self._isPresented = isPresented
        self._selectedSubcategory = State(initialValue: subcategory)
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Item Details") {
                    TextField("Item name", text: $itemName)
                    
                    HStack {
                        TextField("Quantity", text: $quantity)
                            .keyboardType(.decimalPad)
                        
                        Picker("Unit", selection: $unit) {
                            ForEach(commonUnits, id: \.self) { unit in
                                Text(unit).tag(unit)
                            }
                        }
                        .pickerStyle(.menu)
                    }
                    
                    TextField("Par level", text: $parLevel)
                        .keyboardType(.decimalPad)
                    
                    if !availableSubcategories.isEmpty {
                        Picker("Storage Location", selection: $selectedSubcategory) {
                            Text("None").tag(nil as Subcategory?)
                            ForEach(availableSubcategories) { subcategory in
                                Text(subcategory.name).tag(subcategory as Subcategory?)
                            }
                        }
                    }
                }
                
                Section {
                    Text("Par level is the minimum quantity you want to maintain in stock.")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            .navigationTitle("New Item")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        isPresented = false
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Add") {
                        addItem()
                    }
                    .disabled(!isValid)
                }
            }
        }
    }
    
    private var isValid: Bool {
        !itemName.trimmingCharacters(in: .whitespaces).isEmpty &&
        Double(quantity) != nil &&
        Double(parLevel) != nil
    }
    
    private func addItem() {
        guard let qty = Double(quantity),
              let par = Double(parLevel) else { return }
        
        let newItem = InventoryItem(
            name: itemName.trimmingCharacters(in: .whitespaces),
            quantity: qty,
            unit: unit,
            parLevel: par,
            category: category,
            subcategory: selectedSubcategory
        )
        
        context.insert(newItem)
        try? context.save()
        isPresented = false
    }
}

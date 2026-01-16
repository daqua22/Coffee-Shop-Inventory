//
//  EditItemSheet.swift
//  Coffee shop Inventorys
//
//  Created by Dan on 1/15/26.
//

import SwiftUI
import SwiftData

struct EditItemSheet: View {
    @Bindable var item: InventoryItem
    @Binding var isPresented: Bool
    @Environment(\.modelContext) private var context
    
    @State private var itemName: String
    @State private var quantity: String
    @State private var unit: String
    @State private var parLevel: String
    
    let commonUnits = ["kg", "g", "L", "ml", "pcs", "bags", "boxes"]
    
    init(item: InventoryItem, isPresented: Binding<Bool>) {
        self.item = item
        self._isPresented = isPresented
        self._itemName = State(initialValue: item.name)
        self._quantity = State(initialValue: String(format: "%.1f", item.quantity))
        self._unit = State(initialValue: item.unit)
        self._parLevel = State(initialValue: String(format: "%.1f", item.parLevel))
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
                }
            }
            .navigationTitle("Edit Item")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        isPresented = false
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        saveChanges()
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
    
    private func saveChanges() {
        guard let qty = Double(quantity),
              let par = Double(parLevel) else { return }
        
        item.name = itemName.trimmingCharacters(in: .whitespaces)
        item.quantity = qty
        item.unit = unit
        item.parLevel = par
        
        try? context.save()
        isPresented = false
    }
}

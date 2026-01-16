//
//  ItemDetailView.swift
//  Coffee shop Inventorys
//
//  Created by Dan on 1/15/26.
//

import SwiftUI
import SwiftData

struct ItemDetailView: View {
    @Bindable var item: InventoryItem
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    
    @State private var itemName: String
    @State private var quantity: String
    @State private var unit: String
    @State private var parLevel: String
    @State private var isHidden: Bool
    @State private var selectedSubcategory: Subcategory?
    
    let commonUnits = ["kg", "g", "L", "ml", "pcs", "bags", "boxes"]
    
    var availableSubcategories: [Subcategory] {
        item.category?.subcategories.sorted { $0.name < $1.name } ?? []
    }
    
    init(item: InventoryItem) {
        self.item = item
        self._itemName = State(initialValue: item.name)
        self._quantity = State(initialValue: Self.formatInitialNumber(item.quantity))
        self._unit = State(initialValue: item.unit)
        self._parLevel = State(initialValue: Self.formatInitialNumber(item.parLevel))
        self._isHidden = State(initialValue: item.isHidden)
        self._selectedSubcategory = State(initialValue: item.subcategory)
    }
    
    private static func formatInitialNumber(_ value: Double) -> String {
        if value.truncatingRemainder(dividingBy: 1) == 0 {
            return String(format: "%.0f", value)
        } else {
            return String(format: "%.1f", value)
        }
    }
    
    var stockColor: Color {
        switch item.stockStatus {
        case .critical:
            return .red
        case .warning:
            return .orange
        case .good:
            return .green
        }
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Item Information") {
                    TextField("Item name", text: $itemName)
                        .autocorrectionDisabled()
                    
                    HStack {
                        Text("Unit")
                        Spacer()
                        Picker("Unit", selection: $unit) {
                            ForEach(commonUnits, id: \.self) { unit in
                                Text(unit).tag(unit)
                            }
                        }
                        .pickerStyle(.menu)
                    }
                    
                    if !availableSubcategories.isEmpty {
                        Picker("Storage Location", selection: $selectedSubcategory) {
                            Text("None").tag(nil as Subcategory?)
                            ForEach(availableSubcategories) { subcategory in
                                Text(subcategory.name).tag(subcategory as Subcategory?)
                            }
                        }
                    }
                }
                
                Section("Current Stock") {
                    HStack {
                        Text("Quantity")
                        Spacer()
                        TextField("Quantity", text: $quantity)
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                            .frame(width: 100)
                        Text(unit)
                            .foregroundColor(.secondary)
                    }
                    
                    HStack {
                        Text("Par Level")
                        Spacer()
                        TextField("Par level", text: $parLevel)
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                            .frame(width: 100)
                        Text(unit)
                            .foregroundColor(.secondary)
                    }
                }
                
                Section("Stock Status") {
                    HStack {
                        Text("Status")
                        Spacer()
                        HStack(spacing: 8) {
                            Circle()
                                .fill(stockColor)
                                .frame(width: 12, height: 12)
                            Text(statusText)
                                .foregroundColor(stockColor)
                                .fontWeight(.medium)
                        }
                    }
                    
                    if let qty = Double(quantity), let par = Double(parLevel) {
                        let percentage = ((qty / par) * 100).rounded()
                        HStack {
                            Text("Current vs Par")
                            Spacer()
                            Text("\(Int(percentage))%")
                                .foregroundColor(.secondary)
                        }
                    }
                }
                
                Section {
                    Toggle("Hide this item", isOn: $isHidden)
                } footer: {
                    Text("Hidden items can still be viewed by enabling 'Show Hidden Items' in the toolbar.")
                        .font(.caption)
                }
                
                Section {
                    Button(role: .destructive) {
                        deleteItem()
                    } label: {
                        HStack {
                            Spacer()
                            Label("Delete Item", systemImage: "trash")
                            Spacer()
                        }
                    }
                }
            }
            .navigationTitle("Item Details")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
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
    
    private var statusText: String {
        switch item.stockStatus {
        case .critical:
            return "Critical"
        case .warning:
            return "Low Stock"
        case .good:
            return "Good"
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
        item.isHidden = isHidden
        item.subcategory = selectedSubcategory
        
        try? context.save()
        dismiss()
    }
    
    private func deleteItem() {
        context.delete(item)
        try? context.save()
        dismiss()
    }
}


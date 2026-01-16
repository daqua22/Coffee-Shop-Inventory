//
//  AddSubcategorySheet.swift
//  Coffee shop Inventorys
//
//  Created by Dan on 1/15/26.
//

import SwiftUI
import SwiftData

struct AddSubcategorySheet: View {
    let category: Category
    @Binding var isPresented: Bool
    @Environment(\.modelContext) private var context
    @State private var subcategoryName = ""
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Storage Location") {
                    TextField("e.g., Storage Fridge, Back Shelf, Bathroom Cabinet", text: $subcategoryName)
                        .autocorrectionDisabled()
                }
                
                Section {
                    Text("Create storage locations to organize your inventory by where items are kept.")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            .navigationTitle("New Location")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        isPresented = false
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Add") {
                        addSubcategory()
                    }
                    .disabled(subcategoryName.trimmingCharacters(in: .whitespaces).isEmpty)
                }
            }
        }
        .presentationDetents([.medium])
    }
    
    private func addSubcategory() {
        let trimmedName = subcategoryName.trimmingCharacters(in: .whitespaces)
        guard !trimmedName.isEmpty else { return }
        
        let newSubcategory = Subcategory(name: trimmedName, category: category)
        context.insert(newSubcategory)
        
        do {
            try context.save()
            print("Subcategory saved: \(trimmedName)")
        } catch {
            print("Error saving subcategory: \(error)")
        }
        
        isPresented = false
    }
}

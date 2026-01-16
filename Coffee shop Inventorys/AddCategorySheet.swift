//
//  AddCategorySheet.swift
//  Coffee shop Inventorys
//
//  Created by Dan on 1/15/26.
//

import SwiftUI
import SwiftData

struct AddCategorySheet: View {
    @Binding var isPresented: Bool
    @Environment(\.modelContext) private var context
    @State private var categoryName = ""
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Category Name") {
                    TextField("e.g., Weekly, Monthly, Bar, Kitchen", text: $categoryName)
                        .autocorrectionDisabled()
                }
            }
            .navigationTitle("New Category")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        isPresented = false
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Add") {
                        addCategory()
                    }
                    .disabled(categoryName.trimmingCharacters(in: .whitespaces).isEmpty)
                }
            }
        }
        .presentationDetents([.medium])
    }
    
    private func addCategory() {
        let trimmedName = categoryName.trimmingCharacters(in: .whitespaces)
        guard !trimmedName.isEmpty else { return }
        
        let newCategory = Category(name: trimmedName)
        context.insert(newCategory)
        
        do {
            try context.save()
            print("Category saved: \(trimmedName)")
        } catch {
            print("Error saving category: \(error)")
        }
        
        isPresented = false
    }
}

//
//  Models.swift
//  Coffee shop Inventorys
//
//  Created by Dan on 1/15/26.
//

import Foundation
import SwiftData

@Model
final class Category {
    @Attribute(.unique) var id: UUID
    var name: String
    var createdDate: Date
    @Relationship(deleteRule: .cascade, inverse: \InventoryItem.category) var items: [InventoryItem]
    @Relationship(deleteRule: .cascade, inverse: \Subcategory.category) var subcategories: [Subcategory]
    
    init(name: String) {
        self.id = UUID()
        self.name = name
        self.createdDate = Date()
        self.items = []
        self.subcategories = []
    }
}

@Model
final class Subcategory {
    @Attribute(.unique) var id: UUID
    var name: String
    var createdDate: Date
    var category: Category?
    @Relationship(deleteRule: .cascade, inverse: \InventoryItem.subcategory) var items: [InventoryItem]
    
    init(name: String, category: Category? = nil) {
        self.id = UUID()
        self.name = name
        self.createdDate = Date()
        self.category = category
        self.items = []
    }
}

@Model
final class InventoryItem {
    @Attribute(.unique) var id: UUID
    var name: String
    var quantity: Double
    var unit: String
    var parLevel: Double
    var isHidden: Bool
    var createdDate: Date
    var category: Category?
    var subcategory: Subcategory?
    
    init(name: String, quantity: Double, unit: String, parLevel: Double, category: Category? = nil, subcategory: Subcategory? = nil) {
        self.id = UUID()
        self.name = name
        self.quantity = quantity
        self.unit = unit
        self.parLevel = parLevel
        self.isHidden = false
        self.createdDate = Date()
        self.category = category
        self.subcategory = subcategory
    }
    
    var stockStatus: StockStatus {
        let ratio = quantity / parLevel
        if ratio <= 1.0 {
            return .critical
        } else if ratio <= 1.3 {
            return .warning
        } else {
            return .good
        }
    }
    
    enum StockStatus {
        case critical, warning, good
    }
}

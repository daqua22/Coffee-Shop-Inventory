//
//  InventoryItem.swift
//  Coffee shop Inventorys
//
//  Created by Daniil Kozar on 1/10/26.
//

import Foundation
import SwiftData

@Model
final class InventoryItem {
    @Attribute(.unique) var id: UUID
    var name: String
    var quantity: Int
    var unit: String
    var minQuantity: Int

    init(name: String, quantity: Int, unit: String, minQuantity: Int) {
        self.id = UUID()
        self.name = name
        self.quantity = quantity
        self.unit = unit
        self.minQuantity = minQuantity
    }
}

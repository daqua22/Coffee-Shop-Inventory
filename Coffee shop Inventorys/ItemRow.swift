//
//  ItemRow.swift
//  Coffee shop Inventorys
//
//  Created by Dan on 1/15/26.
//

import SwiftUI
import SwiftData

struct ItemRow: View {
    @Bindable var item: InventoryItem
    @Environment(\.modelContext) private var context
    
    var stockColor: Color {
        switch item.stockStatus {
        case .critical:
            return .red
        case .warning:
            return .orange
        case .good:
            return .primary
        }
    }
    
    var body: some View {
        HStack(spacing: 12) {
            VStack(alignment: .leading, spacing: 4) {
                Text(item.name)
                    .font(.headline)
                    .foregroundColor(item.isHidden ? .secondary : .primary)
                    .strikethrough(item.isHidden)
                
                HStack(spacing: 4) {
                    Text("Par: \(formatNumber(item.parLevel)) \(item.unit)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    if item.isHidden {
                        Text("• Hidden")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
            }
            
            Spacer()
            
            HStack(spacing: 8) {
                Button {
                    decreaseQuantity()
                } label: {
                    Image(systemName: "minus.circle.fill")
                        .font(.title2)
                        .foregroundColor(.blue)
                }
                .buttonStyle(.borderless)
                
                Text("\(formatNumber(item.quantity))")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(stockColor)
                    .frame(minWidth: 50)
                    .multilineTextAlignment(.center)
                
                Button {
                    increaseQuantity()
                } label: {
                    Image(systemName: "plus.circle.fill")
                        .font(.title2)
                        .foregroundColor(.blue)
                }
                .buttonStyle(.borderless)
            }
        }
    }
    
    private func formatNumber(_ value: Double) -> String {
        if value.truncatingRemainder(dividingBy: 1) == 0 {
            return String(format: "%.0f", value)
        } else {
            return String(format: "%.1f", value)
        }
    }
    
    private func increaseQuantity() {
        item.quantity += 1
        try? context.save()
    }
    
    private func decreaseQuantity() {
        item.quantity = max(0, item.quantity - 1)
        try? context.save()
    }
}

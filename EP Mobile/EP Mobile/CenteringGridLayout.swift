//
//  CenteringGridLayout.swift
//  EP Mobile
//
//  Created by David Mann on 11/1/25.
//  Copyright © 2025 EP Studios. All rights reserved.
//


import SwiftUI

/// A flexible multi-column grid layout that centers the last partial row.
///
/// Example:
/// ```swift
/// CenteringGridLayout(columns: 2, spacing: 16, itemSpacing: 16)
/// ```
struct CenteringGridLayout: Layout {
    var columns: Int = 2
    var spacing: CGFloat = 16
    var itemSpacing: CGFloat = 16

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        guard !subviews.isEmpty, let availableWidth = proposal.width else { return .zero }

        let columnWidth = (availableWidth - CGFloat(columns - 1) * itemSpacing) / CGFloat(columns)
        var totalHeight: CGFloat = 0
        var i = 0

        while i < subviews.count {
            let itemsInRow = min(columns, subviews.count - i)
            var rowHeight: CGFloat = 0
            for j in 0..<itemsInRow {
                let subview = subviews[i + j]
                let size = subview.sizeThatFits(.init(width: columnWidth, height: nil))
                rowHeight = max(rowHeight, size.height)
            }
            totalHeight += rowHeight
            if i + itemsInRow < subviews.count {
                totalHeight += spacing
            }
            i += itemsInRow
        }

        return .init(width: availableWidth, height: totalHeight)
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        guard !subviews.isEmpty else { return }

        let availableWidth = bounds.width
        let columnWidth = (availableWidth - CGFloat(columns - 1) * itemSpacing) / CGFloat(columns)
        var y = bounds.minY
        var i = 0

        while i < subviews.count {
            let itemsInRow = min(columns, subviews.count - i)
            var sizes: [CGSize] = []
            var rowHeight: CGFloat = 0

            for j in 0..<itemsInRow {
                let size = subviews[i + j].sizeThatFits(.init(width: columnWidth, height: nil))
                sizes.append(size)
                rowHeight = max(rowHeight, size.height)
            }

            // Compute horizontal offset to center partial rows
            let totalRowWidth = CGFloat(itemsInRow) * columnWidth + CGFloat(itemsInRow - 1) * itemSpacing
            let startX = bounds.minX + (availableWidth - totalRowWidth) / 2

            var x = startX
            for j in 0..<itemsInRow {
                let size = sizes[j]
                // Center this subview within its column
                let centeredX = x + (columnWidth - size.width) / 2.0

                subviews[i + j].place(
                    at: CGPoint(x: centeredX, y: y),
                    proposal: .init(width: size.width, height: size.height)
                )
                x += columnWidth + itemSpacing
            }

            y += rowHeight + spacing
            i += itemsInRow
        }
    }
}

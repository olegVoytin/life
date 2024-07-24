//
//  GridManager.swift
//  Life
//
//  Created by Олег Войтин on 05.07.2024.
//

import Foundation

@ProcessingActor
protocol GridManagerProtocol: AnyObject, Sendable {
    var grid: [[SquareEntity]] { get }
    var changedSquaresFootprints: [SquareFootprint] { get }
}

@ProcessingActor
final class GridManager: GridManagerProtocol {

    var grid: [[SquareEntity]] = []

    var changedSquaresFootprints: [SquareFootprint] {
        var footprints = [SquareFootprint]()
        footprints.reserveCapacity(grid.count * (grid.first?.count ?? 0)) // Pre-allocate capacity if possible

        for row in grid {
            for square in row /*where square.changed */{
                footprints.append(square.read())
            }
        }

        return footprints
    }

    init() {
        self.grid = createGrid()
    }

    private func createGrid() -> [[SquareEntity]] {
        var grid: [[SquareEntity]] = []

        for rowIndex in 0..<Constants.gridSide {
            var row: [SquareEntity] = []

            for colIndex in 0..<Constants.gridSide {
                let gridPosition = CGPoint(x: colIndex, y: rowIndex)
                let square = SquareEntity(
                    gridPosition: gridPosition,
                    size: CGSize(width: Constants.blockSide, height: Constants.blockSide),
                    type: .empty,
                    energyLevel: 0,
                    organicLevel: 0
                )

                row.append(square)
            }

            grid.append(row)
        }

        return grid
    }
}

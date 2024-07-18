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
}

@ProcessingActor
final class GridManager: GridManagerProtocol {

    var grid: [[SquareEntity]] = []

    init() {
        self.grid = createGrid()
    }

    private func createGrid() -> [[SquareEntity]] {
        var grid: [[SquareEntity]] = []

        for rowIndex in 0..<Constants.gridSide {
            var row: [SquareEntity] = []

            for colIndex in 0..<Constants.gridSide {
                let position = CGPoint(x: colIndex, y: rowIndex)
                let square = SquareEntity(
                    position: position,
                    size: CGSize(width: Constants.blockSide, height: Constants.blockSide),
                    type: .empty
                )

                row.append(square)
            }

            grid.append(row)
        }

        return grid
    }
}

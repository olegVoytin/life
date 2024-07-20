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
        grid
            .flatMap { $0 }
            .filter { $0.changed }
            .map { $0.read() }
    }

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

//
//  GridManager.swift
//  Life
//
//  Created by Олег Войтин on 05.07.2024.
//

import Foundation

@ProcessingActor
protocol GridManagerProtocol: AnyObject, Sendable {
    var grid: Grid<SquareEntity> { get }
    var changedSquaresFootprints: [SquareFootprint] { get }
}

@ProcessingActor
final class GridManager: GridManagerProtocol {

    let grid: Grid<SquareEntity>

    var changedSquaresFootprints: [SquareFootprint] {
        var footprints = [SquareFootprint]()
        footprints.reserveCapacity(grid.rows * grid.cols) // Pre-allocate capacity if possible

        for rowIndex in 0..<grid.rows {
            for colIndex in 0..<grid.cols {
                let square = grid[rowIndex, colIndex]
                if square.changed {
                    footprints.append(square.read())
                }
            }
        }

        return footprints
    }

    init() {
        grid = createGrid()

        func createGrid() -> Grid<SquareEntity> {
            let gridSide = Constants.gridSide
            let initialValue = SquareEntity(
                gridPosition: CGPoint(x: 0, y: 0),
                size: CGSize(width: Constants.blockSide, height: Constants.blockSide),
                type: .empty,
                energyLevel: 0,
                organicLevel: 0
            )

            var grid = Grid(rows: gridSide, cols: gridSide, initialValue: initialValue)

            for rowIndex in 0..<gridSide {
                for colIndex in 0..<gridSide {
                    let gridPosition = CGPoint(x: colIndex, y: rowIndex)
                    let square = SquareEntity(
                        gridPosition: gridPosition,
                        size: CGSize(width: Constants.blockSide, height: Constants.blockSide),
                        type: .empty,
                        energyLevel: 0,
                        organicLevel: 0
                    )
                    grid[rowIndex, colIndex] = square
                }
            }

            return grid
        }
    }
}

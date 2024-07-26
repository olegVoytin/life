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

    func newPosition(direction: Direction, oldPosition: GridPosition) -> GridPosition?
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
                gridPosition: GridPosition(x: 0, y: 0),
                size: CGSize(width: Constants.blockSide, height: Constants.blockSide),
                type: .empty,
                energyLevel: 0,
                organicLevel: 0
            )

            var grid = Grid(rows: gridSide, cols: gridSide, initialValue: initialValue)

            for rowIndex in 0..<gridSide {
                for colIndex in 0..<gridSide {
                    let gridPosition = GridPosition(x: colIndex, y: rowIndex)
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

    func newPosition(direction: Direction, oldPosition: GridPosition) -> GridPosition? {
        let x = oldPosition.x
        let y = oldPosition.y

        switch direction {
        case .up:
            guard
                grid.rows - 1 >= y + 1,
                grid[y + 1, x].type == .empty
            else { return nil }
            return GridPosition(x: x, y: y + 1)

        case .down:
            guard
                y - 1 >= 0,
                grid[y - 1, x].type == .empty
            else { return nil }
            return GridPosition(x: x, y: y - 1)

        case .left:
            guard
                x - 1 >= 0,
                grid[y, x - 1].type == .empty
            else { return nil }
            return GridPosition(x: x - 1, y: y)

        case .right:
            guard
                grid.cols - 1 >= x + 1,
                grid[y, x + 1].type == .empty
            else { return nil }
            return GridPosition(x: x + 1, y: y)
        }
    }
}

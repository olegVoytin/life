//
//  CellMovementDelegate.swift
//  Life
//
//  Created by Олег Войтин on 05.07.2024.
//

import Foundation

@ProcessingActor
protocol CellMovementDelegate: AnyObject {
    func move(_ cell: Cell, direction: Direction)
}

extension CellsManager: CellMovementDelegate {

    func move(_ cell: Cell, direction: Direction) {
        let grid = gridManager.grid

        let x = cell.gridPosition.x
        let y = cell.gridPosition.y

        let newX = x + direction.deltaX
        let newY = y + direction.deltaY

        guard
            grid.rows - 1 >= y,
            grid.cols - 1 >= x,
            newX >= 0, newX < grid.cols,
            newY >= 0, newY < grid.rows
        else { return }

        let newSquare = grid[newY, newX]

        guard newSquare.type == .empty else { return }

        let oldSquare = grid[y, x]
        oldSquare.type = .empty

        newSquare.type = .cell(type: .cell)

        cell.gridPosition = GridPosition(x: newX, y: newY)
    }
}

private extension Direction {

    var deltaX: Int {
        switch self {
        case .up: 0
        case .down: 0
        case .left: -1
        case .right: 1
        }
    }

    var deltaY: Int {
        switch self {
        case .up: 1
        case .down: -1
        case .left: 0
        case .right: 0
        }
    }
}

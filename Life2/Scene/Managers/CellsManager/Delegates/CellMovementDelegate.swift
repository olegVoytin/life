//
//  CellMovementDelegate.swift
//  Life
//
//  Created by Олег Войтин on 05.07.2024.
//

import Foundation

@ProcessingActor
protocol CellMovementDelegate: AnyObject {
    func moveUp(_ cell: Cell)
    func moveDown(_ cell: Cell)
    func moveLeft(_ cell: Cell)
    func moveRight(_ cell: Cell)
}

extension CellsManager: CellMovementDelegate {

    func moveUp(_ cell: Cell) {
        let grid = gridManager.grid

        let x = Int(cell.gridPosition.x)
        let y = Int(cell.gridPosition.y)

        guard
            grid.rows - 1 >= y,
            grid.cols - 1 >= x,
            grid.cols - 1 >= y + 1
        else { return }

        let newSquare = grid[y + 1, x]

        guard newSquare.type == .empty else { return }

        let oldSquare = grid[y, x]
        oldSquare.type = .empty

        newSquare.type = .cell(type: .cell)

        cell.gridPosition = CGPoint(x: x, y: y + 1)
    }

    func moveDown(_ cell: Cell) {
        let grid = gridManager.grid

        let x = Int(cell.gridPosition.x)
        let y = Int(cell.gridPosition.y)

        guard
            grid.rows - 1 >= y,
            grid.cols - 1 >= x,
            y - 1 >= 0
        else { return }

        let newSquare = grid[y - 1, x]

        guard newSquare.type == .empty else { return }

        let oldSquare = grid[y, x]
        oldSquare.type = .empty

        newSquare.type = .cell(type: .cell)

        cell.gridPosition = CGPoint(x: x, y: y - 1)
    }

    func moveLeft(_ cell: Cell) {
        let grid = gridManager.grid

        let x = Int(cell.gridPosition.x)
        let y = Int(cell.gridPosition.y)

        guard
            grid.rows - 1 >= y,
            grid.cols - 1 >= x,
            x - 1 >= 0
        else { return }

        let newSquare = grid[y, x - 1]

        guard newSquare.type == .empty else { return }

        let oldSquare = grid[y, x]
        oldSquare.type = .empty

        newSquare.type = .cell(type: .cell)

        cell.gridPosition = CGPoint(x: x - 1, y: y)
    }

    func moveRight(_ cell: Cell) {
        let grid = gridManager.grid

        let x = Int(cell.gridPosition.x)
        let y = Int(cell.gridPosition.y)

        guard
            grid.rows - 1 >= y,
            grid.cols - 1 >= x,
            grid.cols - 1 >= x + 1
        else { return }

        let newSquare = grid[y, x + 1]

        guard newSquare.type == .empty else { return }

        let oldSquare = grid[y, x]
        oldSquare.type = .empty

        newSquare.type = .cell(type: .cell)

        cell.gridPosition = CGPoint(x: x + 1, y: y)
    }
}

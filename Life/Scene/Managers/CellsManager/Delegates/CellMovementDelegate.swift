//
//  CellMovementDelegate.swift
//  Life
//
//  Created by Олег Войтин on 05.07.2024.
//

import Foundation

@ProcessingActor
protocol CellMovementDelegate: AnyObject {
    func moveUp(_ cell: Cell) async
    func moveDown(_ cell: Cell) async
    func moveLeft(_ cell: Cell) async
    func moveRight(_ cell: Cell) async
}

extension CellsManager: CellMovementDelegate {

    func moveUp(_ cell: Cell) async {
        let grid = gridManager.grid

        let x = Int(cell.gridPosition.x)
        let y = Int(cell.gridPosition.y)

        guard
            grid.count - 1 >= y,
            grid[y].count - 1 >= x,
            grid.count - 1 >= y + 1
        else { return }

        let newSquare = grid[y + 1][x]

        guard await newSquare.type == .empty else { return }

        let oldSquare = grid[y][x]
        await oldSquare.setType(.empty)

        await newSquare.setType(.cell(type: .cell))

        cell.gridPosition = CGPoint(x: x, y: y + 1)
    }

    func moveDown(_ cell: Cell) async {
        let grid = gridManager.grid

        let x = Int(cell.gridPosition.x)
        let y = Int(cell.gridPosition.y)

        guard
            grid.count - 1 >= y,
            grid[y].count - 1 >= x,
            y - 1 >= 0
        else { return }

        let newSquare = grid[y - 1][x]

        guard await newSquare.type == .empty else { return }

        let oldSquare = grid[y][x]
        await oldSquare.setType(.empty)

        await newSquare.setType(.cell(type: .cell))

        cell.gridPosition = CGPoint(x: x, y: y - 1)
    }

    func moveLeft(_ cell: Cell) async {
        let grid = gridManager.grid

        let x = Int(cell.gridPosition.x)
        let y = Int(cell.gridPosition.y)

        guard
            grid.count - 1 >= y,
            grid[y].count - 1 >= x,
            x - 1 >= 0
        else { return }

        let newSquare = grid[y][x - 1]

        guard await newSquare.type == .empty else { return }

        let oldSquare = grid[y][x]
        await oldSquare.setType(.empty)

        await newSquare.setType(.cell(type: .cell))

        cell.gridPosition = CGPoint(x: x - 1, y: y)
    }

    func moveRight(_ cell: Cell) async {
        let grid = gridManager.grid

        let x = Int(cell.gridPosition.x)
        let y = Int(cell.gridPosition.y)

        guard
            grid.count - 1 >= y,
            grid[y].count - 1 >= x,
            grid[y].count - 1 >= x + 1
        else { return }

        let newSquare = grid[y][x + 1]

        guard await newSquare.type == .empty else { return }

        let oldSquare = grid[y][x]
        await oldSquare.setType(.empty)

        await newSquare.setType(.cell(type: .cell))

        cell.gridPosition = CGPoint(x: x + 1, y: y)
    }
}

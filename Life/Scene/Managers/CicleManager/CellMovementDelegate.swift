//
//  CellMovementDelegate.swift
//  Life
//
//  Created by Олег Войтин on 05.07.2024.
//

import Foundation

@ProcessingActor
protocol CellMovementDelegate: AnyObject {
    func moveUp(from gridPosition: CGPoint) -> Bool
    func moveDown(from gridPosition: CGPoint) -> Bool
    func moveLeft(from gridPosition: CGPoint) -> Bool
    func moveRight(from gridPosition: CGPoint) -> Bool
}

extension CicleManager: CellMovementDelegate {

    func moveUp(from gridPosition: CGPoint) -> Bool {
        let grid = gridManager.grid

        let x = Int(gridPosition.x)
        let y = Int(gridPosition.y)

        guard
            grid.count - 1 >= y,
            grid[y].count - 1 >= x,
            grid.count - 1 >= y + 1
        else { return false }

        let newSquare = grid[y + 1][x]

        guard newSquare.type == .empty else { return false }

        let oldSquare = grid[y][x]
        oldSquare.type = .empty

        newSquare.type = .cell

        return true
    }

    func moveDown(from gridPosition: CGPoint) -> Bool {
        let grid = gridManager.grid

        let x = Int(gridPosition.x)
        let y = Int(gridPosition.y)

        guard
            grid.count - 1 >= y,
            grid[y].count - 1 >= x,
            y - 1 >= 0
        else { return false }

        let newSquare = grid[y - 1][x]

        guard newSquare.type == .empty else { return false }

        let oldSquare = grid[y][x]
        oldSquare.type = .empty

        newSquare.type = .cell

        return true
    }

    func moveLeft(from gridPosition: CGPoint) -> Bool {
        let grid = gridManager.grid

        let x = Int(gridPosition.x)
        let y = Int(gridPosition.y)

        guard
            grid.count - 1 >= y,
            grid[y].count - 1 >= x,
            x - 1 >= 0
        else { return false }

        let newSquare = grid[y][x - 1]

        guard newSquare.type == .empty else { return false }

        let oldSquare = grid[y][x]
        oldSquare.type = .empty

        newSquare.type = .cell

        return true
    }

    func moveRight(from gridPosition: CGPoint) -> Bool {
        let grid = gridManager.grid

        let x = Int(gridPosition.x)
        let y = Int(gridPosition.y)

        guard
            grid.count - 1 >= y,
            grid[y].count - 1 >= x,
            grid[y].count - 1 >= x + 1
        else { return false }

        let newSquare = grid[y][x + 1]

        guard newSquare.type == .empty else { return false }

        let oldSquare = grid[y][x]
        oldSquare.type = .empty

        newSquare.type = .cell

        return true
    }
}

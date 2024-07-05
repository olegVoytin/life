//
//  CellPositionDelegate.swift
//  Life
//
//  Created by Олег Войтин on 05.07.2024.
//

import Foundation

@ProcessingActor
protocol CellPositionDelegate: AnyObject {
    func moveUp(from squarePosition: CGPoint) -> Bool
    func moveDown(from squarePosition: CGPoint) -> Bool
    func moveLeft(from squarePosition: CGPoint) -> Bool
    func moveRight(from squarePosition: CGPoint) -> Bool
}

extension CicleManager: CellPositionDelegate {

    func moveUp(from squarePosition: CGPoint) -> Bool {
        let grid = gridManager.grid

        let x = Int(squarePosition.x)
        let y = Int(squarePosition.y)

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

    func moveDown(from squarePosition: CGPoint) -> Bool {
        false
    }

    func moveLeft(from squarePosition: CGPoint) -> Bool {
        false
    }

    func moveRight(from squarePosition: CGPoint) -> Bool {
        false
    }
}

//
//  CellBirthGivingDelegate.swift
//  Life
//
//  Created by Олег Войтин on 05.07.2024.
//

import Foundation

@ProcessingActor
protocol CellBirthGivingDelegate: AnyObject {
    func giveBirthForward(_ cell: Cell)
    func giveBirthLeft(_ cell: Cell)
    func giveBirthRight(_ cell: Cell)
}

extension CellsManager: CellBirthGivingDelegate {

    func giveBirthForward(_ cell: Cell) {
        let grid = gridManager.grid

        let x = Int(cell.gridPosition.x)
        let y = Int(cell.gridPosition.y)

        guard
            grid.count - 1 >= y,
            grid[y].count - 1 >= x
        else { return }

        var birthPosition: CGPoint?
        switch cell.lookingDirection {
        case .up:
            birthPosition = birthPositionUp(grid: grid, x: x, y: y)

        case .down:
            birthPosition = birthPositionDown(grid: grid, x: x, y: y)

        case .left:
            birthPosition = birthPositionLeft(grid: grid, x: x, y: y)

        case .right:
            birthPosition = birthPositionRight(grid: grid, x: x, y: y)
        }

        guard let birthPosition else { return }

        let oldSquare = grid[y][x]
        oldSquare.type = .cell(type: .transport)
        cell.type = .transport

        self.addChild(of: cell, to: birthPosition)

        let square = gridManager.grid[Int(birthPosition.y)][Int(birthPosition.x)]
        square.type = .cell(type: .cell)
    }

    func giveBirthLeft(_ cell: Cell) {
        let grid = gridManager.grid

        let x = Int(cell.gridPosition.x)
        let y = Int(cell.gridPosition.y)

        guard
            grid.count - 1 >= y,
            grid[y].count - 1 >= x
        else { return }

        var birthPosition: CGPoint?
        switch cell.lookingDirection {
        case .up:
            birthPosition = birthPositionLeft(grid: grid, x: x, y: y)

        case .down:
            birthPosition = birthPositionRight(grid: grid, x: x, y: y)

        case .left:
            birthPosition = birthPositionDown(grid: grid, x: x, y: y)

        case .right:
            birthPosition = birthPositionUp(grid: grid, x: x, y: y)
        }

        guard let birthPosition else { return }

        let oldSquare = grid[y][x]
        oldSquare.type = .cell(type: .transport)
        cell.type = .transport

        self.addChild(of: cell, to: birthPosition)

        let square = gridManager.grid[Int(birthPosition.y)][Int(birthPosition.x)]
        square.type = .cell(type: .cell)
    }

    func giveBirthRight(_ cell: Cell) {
        let grid = gridManager.grid

        let x = Int(cell.gridPosition.x)
        let y = Int(cell.gridPosition.y)

        guard
            grid.count - 1 >= y,
            grid[y].count - 1 >= x
        else { return }

        var birthPosition: CGPoint?
        switch cell.lookingDirection {
        case .up:
            birthPosition = birthPositionRight(grid: grid, x: x, y: y)

        case .down:
            birthPosition = birthPositionLeft(grid: grid, x: x, y: y)

        case .left:
            birthPosition = birthPositionUp(grid: grid, x: x, y: y)

        case .right:
            birthPosition = birthPositionDown(grid: grid, x: x, y: y)
        }

        guard let birthPosition else { return }

        let oldSquare = grid[y][x]
        oldSquare.type = .cell(type: .transport)
        cell.type = .transport

        self.addChild(of: cell, to: birthPosition)

        let square = gridManager.grid[Int(birthPosition.y)][Int(birthPosition.x)]
        square.type = .cell(type: .cell)
    }

    private func birthPositionUp(grid: [[SquareEntity]], x: Int, y: Int) -> CGPoint? {
        guard
            grid.count - 1 >= y + 1,
            grid[y + 1][x].type == .empty
        else { return nil }
        return CGPoint(x: x, y: y + 1)
    }

    private func birthPositionDown(grid: [[SquareEntity]], x: Int, y: Int) -> CGPoint? {
        guard
            y - 1 >= 0,
            grid[y - 1][x].type == .empty
        else { return nil }
        return CGPoint(x: x, y: y - 1)
    }

    private func birthPositionLeft(grid: [[SquareEntity]], x: Int, y: Int) -> CGPoint? {
        guard
            x - 1 >= 0,
            grid[y][x - 1].type == .empty
        else { return nil }
        return CGPoint(x: x - 1, y: y)
    }

    private func birthPositionRight(grid: [[SquareEntity]], x: Int, y: Int) -> CGPoint? {
        guard
            grid[y].count - 1 >= x + 1,
            grid[y][x + 1].type == .empty
        else { return nil }
        return CGPoint(x: x + 1, y: y)
    }
}

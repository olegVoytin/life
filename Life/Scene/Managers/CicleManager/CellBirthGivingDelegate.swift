//
//  CellBirthGivingDelegate.swift
//  Life
//
//  Created by Олег Войтин on 05.07.2024.
//

import Foundation

@ProcessingActor
protocol CellBirthGivingDelegate: AnyObject {
    func giveBirth(_ cell: Cell)
}

extension CicleManager: CellBirthGivingDelegate {

    func giveBirth(_ cell: Cell) {
        let grid = gridManager.grid

        let x = Int(cell.gridPosition.x)
        let y = Int(cell.gridPosition.y)

        guard
            grid.count - 1 >= y,
            grid[y].count - 1 >= x
        else { return }

        let birthPosition: CGPoint? = {
            switch cell.lookingDirection {
            case .up:
                guard
                    grid.count - 1 >= y + 1,
                    grid[y + 1][x].type == .empty
                else { return nil }
                return CGPoint(x: x, y: y + 1)

            case .down:
                guard
                    y - 1 >= 0,
                    grid[y - 1][x].type == .empty
                else { return nil }

                return CGPoint(x: x, y: y - 1)

            case .left:
                guard
                    x - 1 >= 0,
                    grid[y][x - 1].type == .empty
                else { return nil }
                return CGPoint(x: x - 1, y: y)

            case .right:
                guard
                    grid[y].count - 1 >= x + 1,
                    grid[y][x + 1].type == .empty
                else { return nil }
                return CGPoint(x: x + 1, y: y)
            }
        }()

        guard let birthPosition else { return }

        let oldSquare = grid[y][x]
        oldSquare.type = .cell(type: .transport)
        cell.type = .transport

        cellsManager.addChild(of: cell, to: birthPosition)

        let square = gridManager.grid[Int(birthPosition.y)][Int(birthPosition.x)]
        square.type = .cell(type: .cell)

        print("birth gave")
    }
}

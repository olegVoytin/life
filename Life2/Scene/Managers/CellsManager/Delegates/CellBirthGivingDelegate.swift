//
//  CellBirthGivingDelegate.swift
//  Life
//
//  Created by Олег Войтин on 05.07.2024.
//

import Foundation

@ProcessingActor
protocol CellBirthGivingDelegate: AnyObject {
    func giveBirthForward(_ cell: Cell, childType: Cell.CellType)
    func giveBirthLeft(_ cell: Cell, childType: Cell.CellType)
    func giveBirthRight(_ cell: Cell, childType: Cell.CellType)
}

extension CellsManager: CellBirthGivingDelegate {

    func giveBirthForward(_ cell: Cell, childType: Cell.CellType) {
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
            birthPosition = birthPositionUp(x: x, y: y)

        case .down:
            birthPosition = birthPositionDown(x: x, y: y)

        case .left:
            birthPosition = birthPositionLeft(x: x, y: y)

        case .right:
            birthPosition = birthPositionRight(x: x, y: y)
        }

        guard let birthPosition else { return }

        giveBirth(
            parentCell: cell,
            parentPositionX: x,
            parentPositionY: y,
            birthPosition: birthPosition,
            childType: childType
        )
    }

    func giveBirthLeft(_ cell: Cell, childType: Cell.CellType) {
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
            birthPosition = birthPositionLeft(x: x, y: y)

        case .down:
            birthPosition = birthPositionRight(x: x, y: y)

        case .left:
            birthPosition = birthPositionDown(x: x, y: y)

        case .right:
            birthPosition = birthPositionUp(x: x, y: y)
        }

        guard let birthPosition else { return }

        giveBirth(
            parentCell: cell,
            parentPositionX: x,
            parentPositionY: y,
            birthPosition: birthPosition,
            childType: childType
        )
    }

    func giveBirthRight(_ cell: Cell, childType: Cell.CellType) {
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
            birthPosition = birthPositionRight(x: x, y: y)

        case .down:
            birthPosition = birthPositionLeft(x: x, y: y)

        case .left:
            birthPosition = birthPositionUp(x: x, y: y)

        case .right:
            birthPosition = birthPositionDown(x: x, y: y)
        }

        guard let birthPosition else { return }

        giveBirth(
            parentCell: cell,
            parentPositionX: x,
            parentPositionY: y,
            birthPosition: birthPosition,
            childType: childType
        )
    }

    // MARK: - Birth giving

    private func giveBirth(
        parentCell: Cell,
        parentPositionX: Int,
        parentPositionY: Int,
        birthPosition: CGPoint,
        childType: Cell.CellType
    ) {
        let oldSquare = gridManager.grid[parentPositionY][parentPositionX]
        oldSquare.type = .cell(type: .transport)
        parentCell.type = .transport

        let energyToSend: Int = {
            switch childType {
            case .cell:
                return parentCell.energyHolder.energy

            default:
                return 0
            }
        }()
        let child = self.addChild(
            of: parentCell,
            to: birthPosition,
            energy: energyToSend,
            type: childType
        )
        parentCell.energyHolder.energy -= energyToSend

        parentCell.forwardChild = child
        child.parentCell = parentCell

        let square = gridManager.grid[Int(birthPosition.y)][Int(birthPosition.x)]
        square.type = .cell(type: childType)
    }

    // MARK: - Position

    private func birthPositionUp(x: Int, y: Int) -> CGPoint? {
        guard
            gridManager.grid.count - 1 >= y + 1,
            gridManager.grid[y + 1][x].type == .empty
        else { return nil }
        return CGPoint(x: x, y: y + 1)
    }

    private func birthPositionDown(x: Int, y: Int) -> CGPoint? {
        guard
            y - 1 >= 0,
            gridManager.grid[y - 1][x].type == .empty
        else { return nil }
        return CGPoint(x: x, y: y - 1)
    }

    private func birthPositionLeft(x: Int, y: Int) -> CGPoint? {
        guard
            x - 1 >= 0,
            gridManager.grid[y][x - 1].type == .empty
        else { return nil }
        return CGPoint(x: x - 1, y: y)
    }

    private func birthPositionRight(x: Int, y: Int) -> CGPoint? {
        guard
            gridManager.grid[y].count - 1 >= x + 1,
            gridManager.grid[y][x + 1].type == .empty
        else { return nil }
        return CGPoint(x: x + 1, y: y)
    }
}

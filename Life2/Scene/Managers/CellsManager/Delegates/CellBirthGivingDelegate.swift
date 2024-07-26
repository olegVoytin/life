//
//  CellBirthGivingDelegate.swift
//  Life
//
//  Created by Олег Войтин on 05.07.2024.
//

import Foundation

@ProcessingActor
protocol CellBirthGivingDelegate: AnyObject {
    func giveBirth(_ parentCell: Cell, childType: Cell.CellType, birthDirection: Cell.BirthDirection)
}

extension CellsManager: CellBirthGivingDelegate {

    func giveBirth(_ parentCell: Cell, childType: Cell.CellType, birthDirection: Cell.BirthDirection) {
        let grid = gridManager.grid
        let x = parentCell.gridPosition.x
        let y = parentCell.gridPosition.y

        guard grid.rows - 1 >= y, grid.cols - 1 >= x,
            let birthPosition = birthPosition(for: parentCell, birthDirection: birthDirection) else { return }

        let oldSquare = grid[y, x]
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

        let square = grid[birthPosition.y, birthPosition.x]
        square.type = .cell(type: childType)
    }

    // MARK: - Helper Methods

    private func birthPosition(for cell: Cell, birthDirection: Cell.BirthDirection) -> GridPosition? {
        let x = cell.gridPosition.x
        let y = cell.gridPosition.y

        switch birthDirection {
        case .forward:
            return positionBasedOnDirection(cell.lookingDirection, x: x, y: y)
        case .left:
            return positionBasedOnDirection(cell.lookingDirection.leftDirection(), x: x, y: y)
        case .right:
            return positionBasedOnDirection(cell.lookingDirection.rightDirection(), x: x, y: y)
        }
    }

    private func positionBasedOnDirection(
        _ direction: Cell.Direction,
        x: Int,
        y: Int
    ) -> GridPosition? {
        switch direction {
        case .up:
            return birthPositionUp(x: x, y: y)
        case .down:
            return birthPositionDown(x: x, y: y)
        case .left:
            return birthPositionLeft(x: x, y: y)
        case .right:
            return birthPositionRight(x: x, y: y)
        }
    }

    private func birthPositionUp(x: Int, y: Int) -> GridPosition? {
        guard
            gridManager.grid.rows - 1 >= y + 1,
            gridManager.grid[y + 1, x].type == .empty
        else { return nil }
        return GridPosition(x: x, y: y + 1)
    }

    private func birthPositionDown(x: Int, y: Int) -> GridPosition? {
        guard
            y - 1 >= 0,
            gridManager.grid[y - 1, x].type == .empty
        else { return nil }
        return GridPosition(x: x, y: y - 1)
    }

    private func birthPositionLeft(x: Int, y: Int) -> GridPosition? {
        guard
            x - 1 >= 0,
            gridManager.grid[y, x - 1].type == .empty
        else { return nil }
        return GridPosition(x: x - 1, y: y)
    }

    private func birthPositionRight(x: Int, y: Int) -> GridPosition? {
        guard
            gridManager.grid.cols - 1 >= x + 1,
            gridManager.grid[y, x + 1].type == .empty
        else { return nil }
        return GridPosition(x: x + 1, y: y)
    }
}

// Extension for LookingDirection to support left and right directions
private extension Cell.Direction {
    func leftDirection() -> Cell.Direction {
        switch self {
        case .up: return .left
        case .down: return .right
        case .left: return .down
        case .right: return .up
        }
    }

    func rightDirection() -> Cell.Direction {
        switch self {
        case .up: return .right
        case .down: return .left
        case .left: return .up
        case .right: return .down
        }
    }
}

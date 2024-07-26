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
        switch birthDirection {
        case .forward:
            return gridManager.newPosition(
                direction: cell.lookingDirection,
                oldPosition: cell.gridPosition
            )
        case .left:
            return gridManager.newPosition(
                direction: cell.lookingDirection.leftDirection(),
                oldPosition: cell.gridPosition
            )
        case .right:
            return gridManager.newPosition(
                direction: cell.lookingDirection.rightDirection(),
                oldPosition: cell.gridPosition
            )
        }
    }
}

// Extension for LookingDirection to support left and right directions
private extension Direction {
    func leftDirection() -> Direction {
        switch self {
        case .up: return .left
        case .down: return .right
        case .left: return .down
        case .right: return .up
        }
    }

    func rightDirection() -> Direction {
        switch self {
        case .up: return .right
        case .down: return .left
        case .left: return .up
        case .right: return .down
        }
    }
}

//
//  Cell.swift
//  Life
//
//  Created by Олег Войтин on 05.07.2024.
//

import Foundation

@ProcessingActor
final class Cell: Equatable, Identifiable {

    // удалить Int если не нужно генерить рандомное направление
    enum Direction: Int {
        case up = 0, down, left, right
    }

    enum CellType {
        case cell
        case transport
    }

    private weak var cellPositionDelegate: CellMovementDelegate?
    private weak var cellBirthGivingDelegate: CellBirthGivingDelegate?

    var gridPosition: CGPoint
    var energy: Int
    var type: CellType = .cell
    var lookingDirection: Direction = .up

    init(
        cellPositionDelegate: CellMovementDelegate?,
        cellBirthGivingDelegate: CellBirthGivingDelegate?,
        gridPosition: CGPoint,
        energy: Int
    ) {
        self.cellPositionDelegate = cellPositionDelegate
        self.cellBirthGivingDelegate = cellBirthGivingDelegate
        self.gridPosition = gridPosition
        self.energy = energy
    }

    func update() async {
        await giveBirthToLookingDirection()
    }

    nonisolated static func == (lhs: Cell, rhs: Cell) -> Bool {
        lhs.id == rhs.id
    }

    private func giveBirthToLookingDirection() async {
        switch type {
        case .cell:
            await cellBirthGivingDelegate?.giveBirth(self)

        case .transport:
            break
        }
    }

    private func moveRandomly() async {
        guard let direction = Direction(rawValue: Int.random(in: 0..<4)) else { return }

        switch direction {
        case .up:
            await cellPositionDelegate?.moveUp(self)

        case .down:
            await cellPositionDelegate?.moveDown(self)

        case .left:
            await cellPositionDelegate?.moveLeft(self)

        case .right:
            await cellPositionDelegate?.moveRight(self)
        }
    }
}

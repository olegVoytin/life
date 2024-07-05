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

    func update() {
        switch type {
        case .cell:
            print("giving birth")
            cellBirthGivingDelegate?.giveBirth(self)

        case .transport:
            break
        }
    }

    nonisolated static func == (lhs: Cell, rhs: Cell) -> Bool {
        lhs.id == rhs.id
    }

    private func moveRandomly() {
        guard let direction = Direction(rawValue: Int.random(in: 0..<4)) else { return }

        switch direction {
        case .up:
            cellPositionDelegate?.moveUp(self)

        case .down:
            cellPositionDelegate?.moveDown(self)

        case .left:
            cellPositionDelegate?.moveLeft(self)

        case .right:
            cellPositionDelegate?.moveRight(self)
        }
    }
}

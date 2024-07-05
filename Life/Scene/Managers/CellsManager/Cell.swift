//
//  Cell.swift
//  Life
//
//  Created by Олег Войтин on 05.07.2024.
//

import Foundation

@ProcessingActor
final class Cell: Equatable, Identifiable {

    enum MovementDirection: Int, CaseIterable {
        case up = 0, down, left, right
    }

    enum CellType {
        case cell
    }

    private weak var cellPositionDelegate: CellMovementDelegate?
    private var gridPosition: CGPoint

    private var energy: Int
    private var type: CellType = .cell

    init(cellPositionDelegate: CellMovementDelegate?, gridPosition: CGPoint, energy: Int) {
        self.cellPositionDelegate = cellPositionDelegate
        self.gridPosition = gridPosition
        self.energy = energy
    }

    func update() {

    }

    nonisolated static func == (lhs: Cell, rhs: Cell) -> Bool {
        lhs.id == rhs.id
    }

    private func moveRandomly() {
        guard let direction = MovementDirection(rawValue: Int.random(in: 0..<4)) else { return }

        switch direction {
        case .up:
            if cellPositionDelegate?.moveUp(from: gridPosition) == true {
                gridPosition = CGPoint(x: gridPosition.x, y: gridPosition.y + 1)
            }

        case .down:
            if cellPositionDelegate?.moveDown(from: gridPosition) == true {
                gridPosition = CGPoint(x: gridPosition.x, y: gridPosition.y - 1)
            }

        case .left:
            if cellPositionDelegate?.moveLeft(from: gridPosition) == true {
                gridPosition = CGPoint(x: gridPosition.x - 1, y: gridPosition.y)
            }

        case .right:
            if cellPositionDelegate?.moveRight(from: gridPosition) == true {
                gridPosition = CGPoint(x: gridPosition.x + 1, y: gridPosition.y)
            }
        }
    }
}

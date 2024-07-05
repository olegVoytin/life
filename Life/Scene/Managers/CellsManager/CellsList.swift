//
//  CellsList.swift
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

    private weak var cellPositionDelegate: CellPositionDelegate?

    private var squarePosition: CGPoint

    init(cellPositionDelegate: CellPositionDelegate?, squarePosition: CGPoint) {
        self.cellPositionDelegate = cellPositionDelegate
        self.squarePosition = squarePosition
    }

    func update() {
        guard let direction = MovementDirection(rawValue: Int.random(in: 0..<4)) else { return }

        switch direction {
        case .up:
            if cellPositionDelegate?.moveUp(from: squarePosition) == true {
                squarePosition = CGPoint(x: squarePosition.x, y: squarePosition.y + 1)
            }

        case .down:
            if cellPositionDelegate?.moveDown(from: squarePosition) == true {
                squarePosition = CGPoint(x: squarePosition.x, y: squarePosition.y - 1)
            }

        case .left:
            if cellPositionDelegate?.moveLeft(from: squarePosition) == true {
                squarePosition = CGPoint(x: squarePosition.x - 1, y: squarePosition.y)
            }

        case .right:
            if cellPositionDelegate?.moveRight(from: squarePosition) == true {
                squarePosition = CGPoint(x: squarePosition.x + 1, y: squarePosition.y)
            }
        }
    }

    nonisolated static func == (lhs: Cell, rhs: Cell) -> Bool {
        lhs.id == rhs.id
    }
}

@ProcessingActor
final class CellsList: DoublyLinkedList<Cell> {

    weak var cellPositionDelegate: CellPositionDelegate?

    func update() {
        var currentNode = first
        while currentNode != nil {
            currentNode?.value.update()
            currentNode = currentNode?.next
        }
    }

    func addChild(of cell: Cell, to squarePosition: CGPoint) {
        guard let parentCellNode = search(value: cell) else { return }
        let childNode = DoublyLinkedListNode(
            value: Cell(
                cellPositionDelegate: cellPositionDelegate,
                squarePosition: squarePosition
            )
        )

        if let parentPrevious = parentCellNode.previous {
            parentPrevious.next = childNode
        } else {
            prepend(childNode)
        }

        childNode.next = parentCellNode
    }
}

//
//  CellsList.swift
//  Life
//
//  Created by Олег Войтин on 05.07.2024.
//

import Foundation

@ProcessingActor
final class CellsList: DoublyLinkedList<Cell> {

    private weak var cellMovementDelegate: CellMovementDelegate?
    private weak var cellBirthGivingDelegate: CellBirthGivingDelegate?

    init(
        cellMovementDelegate: CellMovementDelegate,
        cellBirthGivingDelegate: CellBirthGivingDelegate
    ) {
        self.cellMovementDelegate = cellMovementDelegate
        self.cellBirthGivingDelegate = cellBirthGivingDelegate
    }

    func update() {
        var currentNode = first
        while currentNode != nil {
            currentNode?.value.update()
            currentNode = currentNode?.next
        }
    }

    func addChild(of cell: Cell, to gridPosition: CGPoint) {
        guard let parentCellNode = search(value: cell) else { return }
        let childNode = DoublyLinkedListNode(
            value: Cell(
                cellMovementDelegate: cellMovementDelegate,
                cellBirthGivingDelegate: cellBirthGivingDelegate,
                gridPosition: gridPosition,
                energy: 100
            )
        )

        childNode.next = parentCellNode

        if let parentPrevious = parentCellNode.previous {
            nodeMap[childNode.value] = childNode
            parentPrevious.next = childNode
        } else {
            prepend(childNode)
        }
    }
}

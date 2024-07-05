//
//  CellsList.swift
//  Life
//
//  Created by Олег Войтин on 05.07.2024.
//

import Foundation

@ProcessingActor
final class CellsList: DoublyLinkedList<Cell> {

    private weak var cellPositionDelegate: CellMovementDelegate?
    private weak var cellBirthGivingDelegate: CellBirthGivingDelegate?

    init(
        cellPositionDelegate: CellMovementDelegate,
        cellBirthGivingDelegate: CellBirthGivingDelegate
    ) {
        self.cellPositionDelegate = cellPositionDelegate
        self.cellBirthGivingDelegate = cellBirthGivingDelegate
    }

    func update() async {
        var currentNode = first
        while currentNode != nil {
            await currentNode?.value.update()
            currentNode = currentNode?.next
        }
    }

    func addChild(of cell: Cell, to gridPosition: CGPoint) {
        guard let parentCellNode = search(value: cell) else { return }
        let childNode = DoublyLinkedListNode(
            value: Cell(
                cellPositionDelegate: cellPositionDelegate,
                cellBirthGivingDelegate: cellBirthGivingDelegate,
                gridPosition: gridPosition,
                energy: 100
            )
        )

        childNode.next = parentCellNode

        if let parentPrevious = parentCellNode.previous {
            parentPrevious.next = childNode
        } else {
            prepend(childNode)
        }
    }
}

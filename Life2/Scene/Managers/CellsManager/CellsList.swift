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
    private weak var cellHarvestDelegate: CellHarvestDelegate?

    init(
        cellMovementDelegate: CellMovementDelegate,
        cellBirthGivingDelegate: CellBirthGivingDelegate,
        cellHarvestDelegate: CellHarvestDelegate
    ) {
        self.cellMovementDelegate = cellMovementDelegate
        self.cellBirthGivingDelegate = cellBirthGivingDelegate
        self.cellHarvestDelegate = cellHarvestDelegate
    }

    func update() {
        var currentNode = first
        while currentNode != nil {
            currentNode?.value.update()
            currentNode = currentNode?.next
        }
    }

    func addChild(of cell: Cell, to gridPosition: CGPoint) -> Cell {
        let newCell = Cell(
            cellMovementDelegate: cellMovementDelegate,
            cellBirthGivingDelegate: cellBirthGivingDelegate, 
            cellHarvestDelegate: cellHarvestDelegate,
            gridPosition: gridPosition,
            energy: 100
        )
        prependNode(with: cell, value: newCell)
        return newCell
    }
}

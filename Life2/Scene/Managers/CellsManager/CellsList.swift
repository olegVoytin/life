//
//  CellsList.swift
//  Life
//
//  Created by Олег Войтин on 05.07.2024.
//

import Foundation

@ProcessingActor
final class CellsList: DoublyLinkedList<Cell> {

    private var cellsCount = 0

    private weak var cellMovementDelegate: CellMovementDelegate?
    private weak var cellBirthGivingDelegate: CellBirthGivingDelegate?
    private weak var cellHarvestDelegate: CellHarvestDelegate?
    private weak var cellDeathDelegate: CellDeathDelegate?

    init(
        cellMovementDelegate: CellMovementDelegate,
        cellBirthGivingDelegate: CellBirthGivingDelegate,
        cellHarvestDelegate: CellHarvestDelegate,
        cellDeathDelegate: CellDeathDelegate
    ) {
        self.cellMovementDelegate = cellMovementDelegate
        self.cellBirthGivingDelegate = cellBirthGivingDelegate
        self.cellHarvestDelegate = cellHarvestDelegate
        self.cellDeathDelegate = cellDeathDelegate
    }

    func update() {
        var currentNode = first
        while currentNode != nil {
            cellsCount += 1

            let updatingNode = currentNode
            currentNode = currentNode?.next

            updatingNode?.value.update()
        }

        print("Cells count: \(cellsCount)")
        cellsCount = 0
    }

    func addChild(of cell: Cell, to gridPosition: CGPoint, energy: Int) -> Cell {
        let newCell = Cell(
            cellMovementDelegate: cellMovementDelegate,
            cellBirthGivingDelegate: cellBirthGivingDelegate, 
            cellHarvestDelegate: cellHarvestDelegate, 
            cellDeathDelegate: cellDeathDelegate,
            gridPosition: gridPosition,
            energy: energy
        )
        prependNode(with: cell, value: newCell)
        return newCell
    }
}

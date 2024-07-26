//
//  CellsList.swift
//  Life
//
//  Created by Олег Войтин on 05.07.2024.
//

import Foundation

enum EnergyPhase {
    case a
    case b
}

@ProcessingActor
final class CellsList: DoublyLinkedList<Cell> {

    private var cellsCount = 0

    private var energyPhase: EnergyPhase = .a

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

            updatingNode?.value.update(energyPhase: energyPhase)
        }

        switch energyPhase {
        case .a:
            energyPhase = .b

        case .b:
            energyPhase = .a
        }

//        print("Cells count: \(cellsCount)")
        cellsCount = 0
    }

    func addChild(
        of cell: Cell,
        to gridPosition: GridPosition,
        energy: Int,
        type: Cell.CellType,
        activeGen: Int
    ) -> Cell {
        let newCell = Cell(
            type: type,
            cellMovementDelegate: cellMovementDelegate,
            cellBirthGivingDelegate: cellBirthGivingDelegate,
            cellHarvestDelegate: cellHarvestDelegate, 
            cellDeathDelegate: cellDeathDelegate,
            gridPosition: gridPosition,
            energy: energy, 
            genome: cell.genome, 
            activeGen: activeGen
        )
        prependNode(with: cell, value: newCell)
        return newCell
    }
}

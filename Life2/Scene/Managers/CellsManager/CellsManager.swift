//
//  CellsManager.swift
//  Life
//
//  Created by Олег Войтин on 05.07.2024.
//

import Foundation

@ProcessingActor
protocol CellsManagerProtocol: AnyObject {
    func update()
    func addCell(to gridPosition: CGPoint)
    func addChild(of cell: Cell, to gridPosition: CGPoint, energy: Int) -> Cell
}

@ProcessingActor
final class CellsManager: CellsManagerProtocol {

    let gridManager: GridManagerProtocol

    lazy var cellsLinkedList = CellsList(
        cellMovementDelegate: self,
        cellBirthGivingDelegate: self,
        cellHarvestDelegate: self, 
        cellDeathDelegate: self
    )

    init(gridManager: GridManagerProtocol) {
        self.gridManager = gridManager
    }

    func update() {
        cellsLinkedList.update()
    }

    func addCell(to gridPosition: CGPoint) {
        let newCell = Cell(
            cellMovementDelegate: self,
            cellBirthGivingDelegate: self, 
            cellHarvestDelegate: self, 
            cellDeathDelegate: self,
            gridPosition: gridPosition,
            energy: 200
        )
        cellsLinkedList.append(value: newCell)
    }

    func addChild(of cell: Cell, to gridPosition: CGPoint, energy: Int) -> Cell {
        cellsLinkedList.addChild(of: cell, to: gridPosition, energy: energy)
    }
}

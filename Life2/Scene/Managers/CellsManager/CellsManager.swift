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
    func addCell(to gridPosition: CGPoint, type: Cell.CellType)
    func addChild(of cell: Cell, to gridPosition: CGPoint, energy: Int, type: Cell.CellType) -> Cell
}

@ProcessingActor
final class CellsManager: CellsManagerProtocol {

    var energyPhase: EnergyPhase = .a

    lazy var cellsLinkedList = CellsList(
        cellMovementDelegate: self,
        cellBirthGivingDelegate: self,
        cellHarvestDelegate: self, 
        cellDeathDelegate: self
    )

    let gridManager: GridManagerProtocol

    init(gridManager: GridManagerProtocol) {
        self.gridManager = gridManager
    }

    func update() {
        cellsLinkedList.update()
    }

    func addCell(to gridPosition: CGPoint, type: Cell.CellType) {
        let newCell = Cell(
            type: type,
            cellMovementDelegate: self,
            cellBirthGivingDelegate: self,
            cellHarvestDelegate: self, 
            cellDeathDelegate: self,
            gridPosition: gridPosition,
            energy: 1000
        )
        cellsLinkedList.append(value: newCell)

        let square = gridManager.grid[Int(gridPosition.y)][Int(gridPosition.x)]
        square.type = .cell(type: .cell)
    }

    func addChild(of cell: Cell, to gridPosition: CGPoint, energy: Int, type: Cell.CellType) -> Cell {
        cellsLinkedList.addChild(of: cell, to: gridPosition, energy: energy, type: type)
    }
}

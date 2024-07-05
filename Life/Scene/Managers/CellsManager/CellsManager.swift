//
//  CellsManager.swift
//  Life
//
//  Created by Олег Войтин on 05.07.2024.
//

import Foundation

@ProcessingActor
protocol CellsManagerProtocol: AnyObject {
    func update() async
    func addCell(to gridPosition: CGPoint)
    func addChild(of cell: Cell, to gridPosition: CGPoint)
}

@ProcessingActor
final class CellsManager: CellsManagerProtocol {

    let gridManager: GridManagerProtocol

    private lazy var cellsLinkedList = CellsList(
        cellPositionDelegate: self,
        cellBirthGivingDelegate: self
    )

    init(gridManager: GridManagerProtocol) {
        self.gridManager = gridManager
    }

    func update() async {
        await cellsLinkedList.update()
    }

    func addCell(to gridPosition: CGPoint) {
        let newCell = Cell(
            cellPositionDelegate: self,
            cellBirthGivingDelegate: self,
            gridPosition: gridPosition,
            energy: 100
        )
        cellsLinkedList.append(value: newCell)
    }

    func addChild(of cell: Cell, to gridPosition: CGPoint) {
        cellsLinkedList.addChild(of: cell, to: gridPosition)
    }
}

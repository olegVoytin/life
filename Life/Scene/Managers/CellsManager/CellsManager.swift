//
//  CellsManager.swift
//  Life
//
//  Created by Олег Войтин on 05.07.2024.
//

import Foundation

@ProcessingActor
protocol CellsManagerProtocol: AnyObject {
    func setUpDelegates(
        cellPositionDelegate: CellMovementDelegate?,
        cellBirthGivingDelegate: CellBirthGivingDelegate?
    )
    func update() async
    func addCell(to gridPosition: CGPoint)
    func addChild(of cell: Cell, to gridPosition: CGPoint)
}

@ProcessingActor
final class CellsManager: CellsManagerProtocol {

    weak var cellPositionDelegate: CellMovementDelegate?
    weak var cellBirthGivingDelegate: CellBirthGivingDelegate?

    private let cellsLinkedList = CellsList()

    func setUpDelegates(
        cellPositionDelegate: CellMovementDelegate?,
        cellBirthGivingDelegate: CellBirthGivingDelegate?
    ) {
        self.cellPositionDelegate = cellPositionDelegate
        self.cellBirthGivingDelegate = cellBirthGivingDelegate

        cellsLinkedList.cellPositionDelegate = cellPositionDelegate
        cellsLinkedList.cellBirthGivingDelegate = cellBirthGivingDelegate
    }

    func update() async {
        await cellsLinkedList.update()
    }

    func addCell(to gridPosition: CGPoint) {
        let newCell = Cell(
            cellPositionDelegate: cellPositionDelegate, 
            cellBirthGivingDelegate: cellBirthGivingDelegate,
            gridPosition: gridPosition,
            energy: 100
        )
        cellsLinkedList.append(value: newCell)
    }

    func addChild(of cell: Cell, to gridPosition: CGPoint) {
        cellsLinkedList.addChild(of: cell, to: gridPosition)
    }
}

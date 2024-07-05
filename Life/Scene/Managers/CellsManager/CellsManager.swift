//
//  CellsManager.swift
//  Life
//
//  Created by Олег Войтин on 05.07.2024.
//

import Foundation

@ProcessingActor
protocol CellsManagerProtocol: AnyObject {
    var cellPositionDelegate: CellMovementDelegate? { get set }

    func update()
    func addCell(to gridPosition: CGPoint)
    func addChild(of cell: Cell, to gridPosition: CGPoint)
}

@ProcessingActor
final class CellsManager: CellsManagerProtocol {

    weak var cellPositionDelegate: CellMovementDelegate?

    private let cellsLinkedList = CellsList()

    func update() {
        cellsLinkedList.update()
    }

    func addCell(to gridPosition: CGPoint) {
        let newCell = Cell(
            cellPositionDelegate: cellPositionDelegate,
            gridPosition: gridPosition,
            energy: 100
        )
        cellsLinkedList.append(value: newCell)
    }

    func addChild(of cell: Cell, to gridPosition: CGPoint) {
        cellsLinkedList.addChild(of: cell, to: gridPosition)
    }
}

//
//  CellsManager.swift
//  Life
//
//  Created by Олег Войтин on 05.07.2024.
//

import Foundation

@ProcessingActor
protocol CellsManagerProtocol: AnyObject {
    var cellPositionDelegate: CellPositionDelegate? { get set }

    func update()
    func addCell(to squarePosition: CGPoint)
    func addChild(of cell: Cell, to squarePosition: CGPoint)
}

@ProcessingActor
final class CellsManager: CellsManagerProtocol {

    weak var cellPositionDelegate: CellPositionDelegate?

    private let cellsLinkedList = CellsList()

    func update() {
        cellsLinkedList.update()
    }

    func addCell(to squarePosition: CGPoint) {
        let newCell = Cell(cellPositionDelegate: cellPositionDelegate, squarePosition: squarePosition)
        cellsLinkedList.append(value: newCell)
    }

    func addChild(of cell: Cell, to squarePosition: CGPoint) {
        cellsLinkedList.addChild(of: cell, to: squarePosition)
    }
}

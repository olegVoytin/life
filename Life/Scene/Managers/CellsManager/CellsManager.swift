//
//  CellsManager.swift
//  Life
//
//  Created by Олег Войтин on 05.07.2024.
//

import Foundation

protocol CellsManagerProtocol: AnyObject {
    func newCicle()
    func addCell(toPosition: CGPoint)
    func addChild(of cell: Cell, toPosition: CGPoint)
}

final class CellsManager: CellsManagerProtocol {

    private let cellsLinkedList = CellsList()

    func newCicle() {
        
    }

    func addCell(toPosition: CGPoint) {
        let newCell = Cell(position: toPosition)
        cellsLinkedList.append(value: newCell)
    }

    func addChild(of cell: Cell, toPosition: CGPoint) {
        cellsLinkedList.addChild(of: cell, toPosition: toPosition)
    }
}

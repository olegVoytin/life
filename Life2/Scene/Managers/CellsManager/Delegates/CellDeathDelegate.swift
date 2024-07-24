//
//  CellDeathDelegate.swift
//  Life2
//
//  Created by Олег Войтин on 22.07.2024.
//

import Foundation

protocol CellDeathDelegate: AnyObject {
    func death(_ cell: Cell)
}

extension CellsManager: CellDeathDelegate {

    func death(_ cell: Cell) {
        if let node = cellsLinkedList.search(value: cell) {
            cellsLinkedList.remove(node: node)
        }

        let grid = gridManager.grid
        let x = Int(cell.gridPosition.x)
        let y = Int(cell.gridPosition.y)

        let square = grid[y][x]
        square.type = .empty
    }
}

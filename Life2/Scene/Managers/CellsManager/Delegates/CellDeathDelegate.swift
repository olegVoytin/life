//
//  CellDeathDelegate.swift
//  Life2
//
//  Created by Олег Войтин on 22.07.2024.
//

import Foundation

@ProcessingActor
protocol CellDeathDelegate: AnyObject {
    func death(_ cell: Cell)
}

extension CellsManager: CellDeathDelegate {

    func death(_ cell: Cell) {
        deleteChildrenReferences(of: cell)
        deleteCellFromLinkedList(cell: cell)
        deleteCellFromGrid(cell: cell)
    }

    private func deleteChildrenReferences(of cell: Cell) {
        if let forwardChild = cell.forwardChild {
            forwardChild.parentCell = nil
            cell.forwardChild = nil
        }

        if let leftChild = cell.leftChild {
            leftChild.parentCell = nil
            cell.leftChild = nil
        }

        if let rightChild = cell.rightChild {
            rightChild.parentCell = nil
            cell.rightChild = nil
        }

        if let parentCell = cell.parentCell {
            if parentCell.forwardChild == cell {
                parentCell.forwardChild = nil
            }

            if parentCell.leftChild == cell {
                parentCell.leftChild = nil
            }

            if parentCell.rightChild == cell {
                parentCell.rightChild = nil
            }
        }
    }

    private func deleteCellFromLinkedList(cell: Cell) {
        if let node = cellsLinkedList.search(value: cell) {
            cellsLinkedList.remove(node: node)
        }
    }

    private func deleteCellFromGrid(cell: Cell) {
        let square = gridManager.grid[cell.gridPosition.y, cell.gridPosition.x]
        square.type = .empty
    }
}

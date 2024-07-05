//
//  CellsList.swift
//  Life
//
//  Created by Олег Войтин on 05.07.2024.
//

import Foundation

final class Cell: Equatable, Identifiable {

    static func == (lhs: Cell, rhs: Cell) -> Bool {
        lhs.id == rhs.id
    }
}

class CellsList: DoublyLinkedList<Cell> {

    func addChild(of cell: Cell) {
        guard let parentCellNode = search(value: cell) else { return }
        let childNode = DoublyLinkedListNode(value: Cell())

        parentCellNode.previous?.next = childNode
        childNode.next = parentCellNode
    }
}

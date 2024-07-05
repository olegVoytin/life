//
//  CellsManager.swift
//  Life
//
//  Created by Олег Войтин on 05.07.2024.
//

import Foundation

protocol CellsManagerProtocol: AnyObject {
    func someFunc()
}

final class CellsManager: CellsManagerProtocol {
    private let cellsLinkedList = CellsList()

    init() {
        cellsLinkedList.append(value: Cell())
        cellsLinkedList.append(value: Cell())
        cellsLinkedList.append(value: Cell())
    }

    func someFunc() {
        print(1)
    }
}

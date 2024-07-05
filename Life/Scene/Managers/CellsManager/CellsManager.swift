//
//  CellsManager.swift
//  Life
//
//  Created by Олег Войтин on 05.07.2024.
//

import Foundation

protocol CellsManagerProtocol {

}

final class CellsManager: CellsManagerProtocol {
    private let cellsLinkedList = DoublyLinkedList<Cell>()
}

//
//  GridObjects.swift
//  Life
//
//  Created by Олег Войтин on 05.07.2024.
//

import Foundation
import Cocoa

@MainActor
final class SquareLayer {

    weak var squareEntity: SquareEntity?
    let layer = CALayer()

    func update() async {
        let texture = await self.squareEntity?.type.texture
        if layer.backgroundColor != texture {
            layer.backgroundColor = texture
        }
    }
}

@ProcessingActor
final class SquareEntity {

    let position: CGPoint
    let size: CGSize
    var type: SquareType

    init(position: CGPoint, size: CGSize, type: SquareType) {
        self.position = position
        self.size = size
        self.type = type
    }

    enum SquareType: Equatable {
        case empty
        case cell(type: Cell.CellType)

        var texture: CGColor {
            switch self {
            case .empty:
                return NSColor.gray.cgColor

            case .cell(let type):
                switch type {
                case .cell:
                    return .white

                case .transport:
                    return NSColor.lightGray.cgColor
                }
            }
        }
    }
}

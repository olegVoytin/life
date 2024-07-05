//
//  GridObjects.swift
//  Life
//
//  Created by Олег Войтин on 05.07.2024.
//

import Foundation
import SpriteKit
import GameplayKit

final class SquareSpriteNode: SKSpriteNode {

    func update() {
        let entity = self.entity as! SquareEntity

        if self.color != entity.type.texture {
            self.color = entity.type.texture
        }
    }
}

final class SquareEntity: GKEntity {
    let position: CGPoint
    let size: CGSize
    var type: SquareType

    init(position: CGPoint, size: CGSize, type: SquareType) {
        self.position = position
        self.size = size
        self.type = type
        super.init()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    enum SquareType: Equatable {
        case empty
        case cell(type: Cell.CellType)

        var texture: NSColor {
            switch self {
            case .empty:
                return .gray

            case .cell(let type):
                switch type {
                case .cell:
                    return .white

                case .transport:
                    return .lightGray
                }
            }
        }
    }
}

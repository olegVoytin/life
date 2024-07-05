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

    enum SquareType {
        case empty
        case cell

        var texture: NSColor {
            switch self {
            case .empty:
                return .gray

            case .cell:
                return .white
            }
        }
    }
}

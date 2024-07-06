//
//  GridObjects.swift
//  Life
//
//  Created by Олег Войтин on 05.07.2024.
//

import Foundation
import SpriteKit

final class SquareSpriteNode: SKSpriteNode {

    weak var squareEntity: SquareEntity?
    
    func update() {
        guard let entity = self.squareEntity else { return }
        
        let texture = entity.type.texture
        if self.color != texture {
            self.color = texture
        }
    }
}

final class SquareEntity: @unchecked Sendable {

    let position: CGPoint
    let size: CGSize
    @MainActor var type: SquareType

    init(position: CGPoint, size: CGSize, type: SquareType) {
        self.position = position
        self.size = size
        self.type = type
    }

    @MainActor
    func setType(_ newType: SquareType) {
        self.type = newType
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

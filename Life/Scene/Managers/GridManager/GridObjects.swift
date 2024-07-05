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
        Task { @MainActor in
            guard let entity = self.squareEntity else { return }

            let texture = await entity.type.read().texture
            if self.color != texture {
                self.color = texture
            }
        }
    }
}

final class SquareEntity: @unchecked Sendable {

    let position: CGPoint
    let size: CGSize
    var type: Atomic<SquareType>

    init(position: CGPoint, size: CGSize, type: SquareType) {
        self.position = position
        self.size = size
        self.type = Atomic(type)
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

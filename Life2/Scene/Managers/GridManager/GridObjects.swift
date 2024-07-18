//
//  GridObjects.swift
//  Life
//
//  Created by Олег Войтин on 05.07.2024.
//

import Foundation
import Cocoa
import MetalKit

@MainActor
final class SquareLayer {

    weak var squareEntity: SquareEntity?

    let position: CGPoint
    var color: CGColor

    init(
        squareEntity: SquareEntity?,
        position: CGPoint,
        color: CGColor = SquareEntity.SquareType.empty.texture
    ) {
        self.squareEntity = squareEntity
        self.position = position
        self.color = color
    }

    func update() async {
        async let changed = await self.squareEntity!.changed
        async let texture = await self.squareEntity!.getType().texture

        guard await changed else { return }

        if await color != texture {
            color = await texture
        }
    }
}

@ProcessingActor
final class SquareEntity {

    let position: CGPoint
    let size: CGSize
    private var type: SquareType

    private(set) var changed = false

    init(position: CGPoint, size: CGSize, type: SquareType) {
        self.position = position
        self.size = size
        self.type = type
    }

    func setType(_ newType: SquareType) {
        type = newType
        changed = true
    }

    func getType() -> SquareType {
        changed = false
        return type
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

extension CGColor {
    var vector: vector_float4 {
        vector_float4(
            Float(self.components![0]),
            Float(self.components![1]),
            Float(self.components![2]),
            Float(self.components![3])
        )
    }
}

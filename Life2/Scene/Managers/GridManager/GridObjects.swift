//
//  GridObjects.swift
//  Life
//
//  Created by Олег Войтин on 05.07.2024.
//

import Foundation
import Cocoa
import MetalKit

struct SquareFootprint {
    let gridPosition: CGPoint
    let color: NSColor
}

final class SquareEntity {

    let gridPosition: CGPoint
    let size: CGSize
    
    var type: SquareType

    var energyLevel: Int
    var organicLevel: Int

    var changed: Bool {
        return self.type != self.lastReadedType
    }
    private var lastReadedType: SquareType?

    init(gridPosition: CGPoint, size: CGSize, type: SquareType, energyLevel: Int, organicLevel: Int) {
        self.gridPosition = gridPosition
        self.size = size
        self.type = type
        self.energyLevel = energyLevel
        self.organicLevel = organicLevel
    }

    func read() -> SquareFootprint {
        lastReadedType = type
        return SquareFootprint(gridPosition: gridPosition, color: type.texture)
    }

    enum SquareType: Equatable {
        case empty
        case cell(type: Cell.CellType)

        var texture: NSColor {
            switch self {
            case .empty:
                return .gray.usingColorSpace(.sRGB)!

            case .cell(let type):
                switch type {
                case .cell:
                    return .white.usingColorSpace(.sRGB)!

                case .transport:
                    return .lightGray.usingColorSpace(.sRGB)!

                case .energyGetter:
                    return .blue.usingColorSpace(.sRGB)!

                case .organicGetter:
                    return .red.usingColorSpace(.sRGB)!

                case .leaf:
                    return .green.usingColorSpace(.sRGB)!
                }
            }
        }
    }
}

extension NSColor {
    var vector: vector_float4 {
        vector_float4(
            Float(self.redComponent),
            Float(self.greenComponent),
            Float(self.blueComponent),
            Float(self.alphaComponent)
        )
    }
}

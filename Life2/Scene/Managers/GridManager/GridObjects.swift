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
    let position: CGPoint
    let color: NSColor
}

@ProcessingActor
final class SquareEntity {

    let position: CGPoint
    let size: CGSize
    private(set) var type: SquareType

    var changed: Bool {
        return self.type != self.lastReadedType
    }
    private var lastReadedType: SquareType?

    init(position: CGPoint, size: CGSize, type: SquareType) {
        self.position = position
        self.size = size
        self.type = type
    }

    func setType(_ newType: SquareType) {
        type = newType
    }

    func read() -> SquareFootprint {
        lastReadedType = type
        return SquareFootprint(position: position, color: type.texture)
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

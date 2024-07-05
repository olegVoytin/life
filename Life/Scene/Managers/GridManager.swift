//
//  GridManager.swift
//  Life
//
//  Created by Олег Войтин on 05.07.2024.
//

import Foundation
import SpriteKit

@ProcessingActor
protocol GridManagerProtocol: Sendable {
    var grid: [[SquareObject]] { get }
    @MainActor func getSquareSpriteNodes() async -> [SKSpriteNode]
}

@ProcessingActor
final class GridManager: GridManagerProtocol {

    var grid: [[SquareObject]] = [[]]

    private let gridSide = 50

    init() {
        self.grid = createGrid()
    }

    private func createGrid() -> [[SquareObject]] {
        var grid: [[SquareObject]] = [[]]

        for rowIndex in 0..<gridSide {
            var row: [SquareObject] = []

            for colIndex in 0..<gridSide {
                let position = CGPoint(
                    x: (colIndex - (gridSide / 2)) * Constants.blockSide,
                    y: (rowIndex - (gridSide / 2)) * Constants.blockSide
                )
                let square = SquareObject(
                    position:position ,
                    size: CGSize(width: Constants.blockSide, height: Constants.blockSide),
                    type: .some(
                        color: NSColor(
                            red: CGFloat(position.x.truncatingRemainder(dividingBy: 255)),
                            green: CGFloat(position.y.truncatingRemainder(dividingBy: 255)),
                            blue: 255,
                            alpha: 1
                        )
                    )
                )

                row.append(square)
            }

            grid.append(row)
        }

        return grid
    }

    @MainActor
    func getSquareSpriteNodes() async -> [SKSpriteNode] {
        let grid = await self.grid
        var spriteNodes: [SKSpriteNode] = []

        for row in grid {
            for square in row {
                let squareSpriteNode = SKSpriteNode(color: square.type.texture, size: square.size)

                squareSpriteNode.position = square.position

                spriteNodes.append(squareSpriteNode)
            }
        }

        return spriteNodes
    }
}


// MARK: - Objects

struct SquareObject {
    let position: CGPoint
    let size: CGSize
    let type: SquareType

    enum SquareType {
        case empty
        case some(color: NSColor)

        var texture: NSColor {
            switch self {
            case .empty:
                return .gray

            case .some(let color):
                return color
            }
        }
    }
}

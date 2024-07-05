//
//  GridManager.swift
//  Life
//
//  Created by Олег Войтин on 05.07.2024.
//

import Foundation
import SpriteKit
import GameplayKit

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
                    type: .empty
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
                squareSpriteNode.entity = square

                spriteNodes.append(squareSpriteNode)
            }
        }

        return spriteNodes
    }
}


// MARK: - Objects

final class SquareObject: GKEntity {
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
                return .green
            }
        }
    }
}

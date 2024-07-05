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
protocol GridManagerProtocol: AnyObject, Sendable {
    var gridSide: Int { get }
    var grid: [[SquareEntity]] { get }
    @MainActor var sprites: [SquareSpriteNode] { get async }
}

@ProcessingActor
final class GridManager: GridManagerProtocol {

    var grid: [[SquareEntity]] = []

    var sprites: [SquareSpriteNode] {
        get async {
            await spritesTask.value
        }

    }
    private lazy var spritesTask = Task<[SquareSpriteNode], Never> {
        await createSquareSpriteNodes()
    }

    let gridSide = 50

    init() {
        self.grid = createGrid()
    }

    private func createGrid() -> [[SquareEntity]] {
        var grid: [[SquareEntity]] = []

        for rowIndex in 0..<gridSide {
            var row: [SquareEntity] = []

            for colIndex in 0..<gridSide {
                let position = CGPoint(
                    x: (colIndex - (gridSide / 2)) * Constants.blockSide,
                    y: (rowIndex - (gridSide / 2)) * Constants.blockSide
                )
                let square = SquareEntity(
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
    private func createSquareSpriteNodes() async -> [SquareSpriteNode] {
        let grid = await self.grid
        var spriteNodes: [SquareSpriteNode] = []

        for row in grid {
            for square in row {
                let squareSpriteNode = SquareSpriteNode(color: square.type.texture, size: square.size)

                squareSpriteNode.position = square.position
                squareSpriteNode.entity = square
                squareSpriteNode.anchorPoint = CGPoint(x: 0, y: 0)

                spriteNodes.append(squareSpriteNode)
            }
        }

        return spriteNodes
    }
}

//
//  GridManager.swift
//  Life
//
//  Created by Олег Войтин on 05.07.2024.
//

import Foundation

@ProcessingActor
protocol GridManagerProtocol: AnyObject, Sendable {
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

    init() {
        self.grid = createGrid()
    }

    private func createGrid() -> [[SquareEntity]] {
        var grid: [[SquareEntity]] = []

        for rowIndex in 0..<Constants.gridSide {
            var row: [SquareEntity] = []

            for colIndex in 0..<Constants.gridSide {
                let position = CGPoint(x: colIndex, y: rowIndex).fromGridPosition()
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
                let texture = square.type.texture
                let squareSpriteNode = SquareSpriteNode(color: texture, size: square.size)

                squareSpriteNode.position = square.position
                squareSpriteNode.squareEntity = square
                squareSpriteNode.anchorPoint = CGPoint(x: 0, y: 0)

                spriteNodes.append(squareSpriteNode)
            }
        }

        return spriteNodes
    }
}

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
    @MainActor var layers: [SquareLayer] { get async }
}

@ProcessingActor
final class GridManager: GridManagerProtocol {

    var grid: [[SquareEntity]] = []

    var layers: [SquareLayer] {
        get async {
            await layersTask.value
        }

    }
    private lazy var layersTask = Task<[SquareLayer], Never> {
        await createSquareLayers()
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
    private func createSquareLayers() async -> [SquareLayer] {
        let grid = await self.grid
        var squareLayers: [SquareLayer] = []

        for row in grid {
            for square in row {
                let squareLayer = SquareLayer()

                squareLayer.layer.frame = CGRect(
                    x: 0,
                    y: 0,
                    width: Constants.blockSide,
                    height: Constants.blockSide
                )
                squareLayer.layer.backgroundColor = await square.type.texture
                squareLayer.layer.position = square.position
                squareLayer.squareEntity = square
                squareLayer.layer.anchorPoint = CGPoint(x: 0, y: 0)

                squareLayers.append(squareLayer)
            }
        }

        return squareLayers
    }
}

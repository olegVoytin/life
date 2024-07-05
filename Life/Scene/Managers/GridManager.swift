//
//  GridManager.swift
//  Life
//
//  Created by Олег Войтин on 05.07.2024.
//

import Foundation

@ProcessingActor
protocol GridManagerProtocol: Sendable {
    var grid: [[SquareObject]] { get }
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
                let square = SquareObject(
                    position: CGPoint(x: colIndex * Constants.blockSide, y: rowIndex * Constants.blockSide),
                    size: CGSize(width: Constants.blockSide, height: Constants.blockSide),
                    type: .some
                )

                row.append(square)
            }

            grid.append(row)
        }

        return grid
    }
}

// MARK: - Objects

struct SquareObject {
    let position: CGPoint
    let size: CGSize
    let type: SquareType

    enum SquareType {
        case empty
        case some
    }
}

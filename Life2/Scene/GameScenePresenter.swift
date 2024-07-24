//
//  GameScenePresenter.swift
//  Life
//
//  Created by Олег Войтин on 04.07.2024.
//

import Foundation

protocol GameScenePresenterProtocol: AnyObject {
    func start()
    func onTap(position: CGPoint)
}

final class GameScenePresenter: GameScenePresenterProtocol {
    
    weak var scene: GameSceneProtocol?

    private lazy var gridManager: GridManagerProtocol = GridManager()
    private lazy var cellsManager: CellsManagerProtocol = CellsManager(gridManager: gridManager)
    private lazy var cycleManager: CycleManagerProtocol = CycleManager(cellsManager: cellsManager)

    // MARK: - Setup

    func start() {
//        Task { @MainActor in
            for _ in 1...100 {
                let randomX = Int.random(in: 0..<Constants.gridSide)
                let randomY = Int.random(in: 0..<Constants.gridSide)
                cellsManager.addCell(to: CGPoint(x: randomX, y: randomY))
            }

//            cellsManager.addCell(to: CGPoint(x: 4, y: 0))
//            cellsManager.addCell(to: CGPoint(x: 5, y: 0))

            cycleManager.startCycle()
//        }

        Task { @MainActor in
            while true {
                updateChangedSquares()
//                await Task.yield()
                try? await Task.sleep(for: .seconds(0.1))
            }
        }
    }

    private func updateChangedSquares() {
        let changedSquaresFootprints = gridManager.changedSquaresFootprints
        guard !changedSquaresFootprints.isEmpty else { return }

        changedSquaresFootprints.forEach {
            scene?.changeColorOfSquare(
                atRow: Int($0.gridPosition.y),
                column: Int($0.gridPosition.x),
                toColor: $0.color.vector
            )
        }
    }

    // MARK: - Actions

    func onTap(position: CGPoint) {
        Task { @MainActor in
            let grid = gridManager.grid

            let gridPosition = position.toGridPosition()
            let x = Int(gridPosition.x)
            let y = Int(gridPosition.y)

            guard
                x >= 0,
                y >= 0,
                grid.count - 1 >= y,
                grid[y].count - 1 >= x
            else { return }

            let square = grid[y][x]
            square.type = .cell(type: .cell)

            cellsManager.addCell(to: gridPosition)
        }
    }
}

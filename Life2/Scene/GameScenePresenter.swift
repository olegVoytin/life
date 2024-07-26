//
//  GameScenePresenter.swift
//  Life
//
//  Created by Олег Войтин on 04.07.2024.
//

import Foundation

@globalActor
actor ProcessingActor {
    static let shared = ProcessingActor()
    private init() {}
}

@MainActor
protocol GameScenePresenterProtocol: AnyObject {
    func start()
    func onTap(position: CGPoint)
}

@MainActor
final class GameScenePresenter: GameScenePresenterProtocol {
    
    weak var scene: GameSceneProtocol?

    @ProcessingActor private lazy var gridManager: GridManagerProtocol = GridManager()
    @ProcessingActor private lazy var cellsManager: CellsManagerProtocol = CellsManager(gridManager: gridManager)
    @ProcessingActor private lazy var cycleManager: CycleManagerProtocol = CycleManager(cellsManager: cellsManager)

    // MARK: - Setup

    func start() {
        Task { @ProcessingActor in
            for _ in 1...1000 {
                let randomX = Int.random(in: 0..<Constants.gridSide)
                let randomY = Int.random(in: 0..<Constants.gridSide)
                cellsManager.addCell(to: GridPosition(x: randomX, y: randomY), type: .cell)
            }

            cycleManager.startCycle()
        }

        Task { @MainActor in
            while true {
                await updateChangedSquares()
                try? await Task.sleep(for: .seconds(0.1))
            }
        }
    }

    private func updateChangedSquares() async {
        let changedSquaresFootprints = await gridManager.changedSquaresFootprints
        guard !changedSquaresFootprints.isEmpty else { return }

        changedSquaresFootprints.forEach {
            scene?.changeColorOfSquare(
                atRow: $0.gridPosition.y,
                column: $0.gridPosition.x,
                toColor: $0.color.vector
            )
        }
    }

    // MARK: - Actions

    func onTap(position: CGPoint) {
        Task { @ProcessingActor in
            let grid = gridManager.grid

            let gridPosition = position.toGridPosition()
            let x = gridPosition.x
            let y = gridPosition.y

            guard
                x >= 0,
                y >= 0
            else { return }

            let square = grid[y, x]
            square.type = .cell(type: .cell)

            cellsManager.addCell(to: gridPosition, type: .cell)
        }
    }
}

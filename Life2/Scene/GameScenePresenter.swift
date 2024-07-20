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
            cycleManager.startCycle()

            for _ in 1...10000 {
                let randomX = Int.random(in: 0..<Constants.gridSide)
                let randomY = Int.random(in: 0..<Constants.gridSide)
                cellsManager.addCell(to: CGPoint(x: randomX, y: randomY))
            }
        }

        Task { @MainActor in
            while true {
                async let limit: ()? = nil//try? await Task.sleep(for: .seconds(0.5))
                async let cycle: () = updateChangedSquares()

                _ = await (
                    limit,
                    cycle
                )
            }
        }
    }

    private func updateChangedSquares() async {
        let changedSquaresFootprints = await gridManager.changedSquaresFootprints
        guard !changedSquaresFootprints.isEmpty else { return }

        Task { @MainActor in
            changedSquaresFootprints.forEach {
                scene?.changeColorOfSquare(
                    atRow: Int($0.position.y),
                    column: Int($0.position.x),
                    toColor: $0.color.vector
                )
            }
        }
    }

    // MARK: - Actions

    func onTap(position: CGPoint) {
        Task { @ProcessingActor in
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

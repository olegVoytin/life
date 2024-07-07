//
//  GameScenePresenter.swift
//  Life
//
//  Created by Олег Войтин on 04.07.2024.
//

import Foundation
import AppKit

@globalActor
actor ProcessingActor {
    static let shared = ProcessingActor()
    private init() {}
}

@MainActor
protocol GameScenePresenterProtocol: AnyObject {
    func start()
    func updateScene() async
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
        setupGrid()

        Task { @ProcessingActor in
            cycleManager.startCycle()
        }
    }

    private func setupGrid() {
        Task {
            let layers = await gridManager.layers
            layers.forEach {
                scene?.addSublayer($0.layer)
            }
        }
    }

    // MARK: - Actions

    func updateScene() async {
        Task { @ProcessingActor in
            cycleManager.onNewFrame()
        }

        let layers = await gridManager.layers
        for layer in layers {
            await layer.update()
        }
    }

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

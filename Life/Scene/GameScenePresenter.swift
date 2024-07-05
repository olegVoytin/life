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
    func updateScene()
    func onTap(position: CGPoint)
}

@MainActor
final class GameScenePresenter: GameScenePresenterProtocol {
    
    weak var scene: GameSceneProtocol?

    private let cameraManager: CameraManagerProtocol = CameraManager()
    @ProcessingActor private lazy var gridManager: GridManagerProtocol = GridManager()
    @ProcessingActor private lazy var cellsManager: CellsManagerProtocol = CellsManager(gridManager: gridManager)
    @ProcessingActor private lazy var cicleManager: CicleManagerProtocol = CicleManager(cellsManager: cellsManager)

    // MARK: - Setup

    func start() {
        setupGrid()
        setupCamera()

        Task { @ProcessingActor in
            cicleManager.startCicle()
        }
    }

    private func setupGrid() {
        Task {
            let sprites = await gridManager.sprites
            sprites.forEach {
                scene?.addChildNode($0)
            }
        }
    }

    private func setupCamera() {
        guard let scene else { return }

        let cameraNode = cameraManager.cameraNode
        scene.addCamera(cameraNode)

        let panGesture = NSPanGestureRecognizer(
            target: cameraManager,
            action: #selector(CameraManager.handlePanGesture(_:))
        )
        scene.addGesture(panGesture)

        let zoomGesture = NSMagnificationGestureRecognizer(
            target: cameraManager,
            action: #selector(CameraManager.handleZoomGesture(_:))
        )
        scene.addGesture(zoomGesture)
    }

    // MARK: - Actions

    func updateScene() {
        Task { @ProcessingActor in
            cicleManager.onNewFrame()
        }

        Task { @MainActor in
            let sprites = await gridManager.sprites

            await withTaskGroup(of: Void.self) { taskGroup in
                for sprite in sprites {
                    taskGroup.addTask {
                        await sprite.update()
                    }
                }
            }
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
            await square.type.write(.cell(type: .cell))

            cellsManager.addCell(to: gridPosition)
        }
    }
}

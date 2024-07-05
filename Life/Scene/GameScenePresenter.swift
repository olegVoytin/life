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
    @ProcessingActor private lazy var cellsManager: CellsManagerProtocol = CellsManager()
    @ProcessingActor private lazy var cicleManager: CicleManagerProtocol = CicleManager(
        gridManager: gridManager,
        cellsManager: cellsManager
    )

    func start() {
        setupGrid()
        setupCamera()

        Task { @ProcessingActor in
            cicleManager.startCicle()
        }
    }

    func updateScene() {
        Task { @MainActor in
            let sprites = await gridManager.sprites
            sprites.forEach {
                $0.update()
            }
        }
    }

    func onTap(position: CGPoint) {
        Task { @ProcessingActor in
            let row = Int(floor(position.y / CGFloat(Constants.blockSide))) + (gridManager.gridSide / 2)
            let col = Int(floor(position.x / CGFloat(Constants.blockSide))) + (gridManager.gridSide / 2)
            let square = gridManager.grid[row][col]
            square.type = .cell

            cellsManager.addCell(to: CGPoint(x: col, y: row))
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

    private func setupGrid() {
        Task {
            let sprites = await gridManager.sprites
            sprites.forEach {
                scene?.addChildNode($0)
            }
        }
    }
}

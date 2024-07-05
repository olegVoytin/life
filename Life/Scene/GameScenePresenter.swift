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

    func start() {
        setupGrid()
        setupCamera()

        Task { @ProcessingActor in
            while true {
                cellsManager.newCicle()

                await Task.yield()
            }
        }
    }

    func updateScene() async {
        await gridManager.getSquareSpriteNodes()
    }

    func onTap(position: CGPoint) {
        Task { @ProcessingActor in
            let row = Int(position.y) / Constants.blockSide
            let col = Int(position.x) / Constants.blockSide
            let square = gridManager.grid[row][col]
            square.type = .cell

            cellsManager.addCell(toPosition: position)
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
            let sprites = await gridManager.getSquareSpriteNodes()
            sprites.forEach {
                scene?.addChildNode($0)
            }
        }
    }
}

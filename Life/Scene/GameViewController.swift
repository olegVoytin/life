//
//  GameViewController.swift
//  Life
//
//  Created by Олег Войтин on 04.07.2024.
//

import Cocoa
import SpriteKit

@MainActor
protocol GameSceneProtocol: AnyObject {
    func addGesture(_ gestureRecognizer: NSGestureRecognizer)
    func addSublayer(_ sublayer: CALayer)
}

class GameViewController: NSViewController, GameSceneProtocol {

    @IBOutlet var gameView: NSView!

    private let presenter = GameScenePresenter()
    private lazy var cameraManager = CameraManager(view: gameView)

    override func viewDidLoad() {
        super.viewDidLoad()

        presenter.scene = self
        presenter.start()

        setupGestureRecognizers()

        Task { @MainActor in
            while true {
                await presenter.updateScene()
                await Task.yield()
            }
        }
    }

    private func setupGestureRecognizers() {
        let panGestureRecognizer = NSPanGestureRecognizer(
            target: cameraManager,
            action: #selector(cameraManager.handlePanGesture(_:))
        )
        let zoomGestureRecognizer = NSMagnificationGestureRecognizer(
            target: cameraManager,
            action: #selector(cameraManager.handleZoomGesture(_:))
        )

        self.view.addGestureRecognizer(panGestureRecognizer)
        self.view.addGestureRecognizer(zoomGestureRecognizer)
    }

    override func mouseDown(with event: NSEvent) {
//        let position = event.location(in: self)
//        presenter.onTap(position: position)
    }

    func addGesture(_ gestureRecognizer: NSGestureRecognizer) {
        self.gameView.addGestureRecognizer(gestureRecognizer)
    }

    func addSublayer(_ sublayer: CALayer) {
        self.gameView.layer?.addSublayer(sublayer)
    }
}

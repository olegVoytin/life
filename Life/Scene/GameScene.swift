//
//  GameScene.swift
//  Life
//
//  Created by Олег Войтин on 04.07.2024.
//

import SpriteKit
import GameplayKit

@MainActor
protocol GameSceneProtocol: AnyObject {
    func addGesture(_ gestureRecognizer: NSGestureRecognizer)
    func addChildNode(_ childNode: SKNode)
    func addCamera(_ cameraNode: SKCameraNode)
}

class GameScene: SKScene, GameSceneProtocol {

    private let presenter: GameScenePresenterProtocol

    init(presenter: GameScenePresenterProtocol) {
        self.presenter = presenter
        super.init(size: CGSize(width: 1000, height: 1000))
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func didMove(to view: SKView) {
        presenter.start()
    }

    override func update(_ currentTime: TimeInterval) {
    }

    func addGesture(_ gestureRecognizer: NSGestureRecognizer) {
        self.view?.addGestureRecognizer(gestureRecognizer)
    }

    func addChildNode(_ childNode: SKNode) {
        self.addChild(childNode)
    }

    func addCamera(_ cameraNode: SKCameraNode) {
        self.camera = cameraNode
        self.addChild(cameraNode)
    }
}

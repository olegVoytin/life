//
//  GameScene.swift
//  Life
//
//  Created by Олег Войтин on 04.07.2024.
//

import SpriteKit
import GameplayKit

protocol GameSceneProtocol: AnyObject {

}

class GameScene: SKScene, GameSceneProtocol {

    private let presenter: GameScenePresenterProtocol

    init(presenter: GameScenePresenterProtocol) {
        self.presenter = presenter
        super.init(size: CGSize(width: 100, height: 100))
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func didMove(to view: SKView) {
        presenter.start()

        let node = SKSpriteNode(color: .red, size: CGSize(width: 50, height: 50))
        self.addChild(node)
    }

    override func update(_ currentTime: TimeInterval) {

    }
}

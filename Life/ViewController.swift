//
//  ViewController.swift
//  Life
//
//  Created by Олег Войтин on 04.07.2024.
//

import Cocoa
import SpriteKit
import GameplayKit

class ViewController: NSViewController {

    @IBOutlet var skView: SKView!

    override func viewDidLoad() {
        super.viewDidLoad()

        let scene = createScene()

        // Present the scene
        if let view = self.skView {
            view.presentScene(scene)

            view.ignoresSiblingOrder = true

            view.showsFPS = true
            view.showsNodeCount = true
        }
    }

    private func createScene() -> SKScene {
        let presenter = GameScenePresenter()
        let scene = GameScene(presenter: presenter)

        scene.scaleMode = .aspectFill
        scene.anchorPoint = CGPoint(x: 50, y: 50)

        presenter.scene = scene

        return scene
    }
}


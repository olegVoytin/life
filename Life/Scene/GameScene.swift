//
//  GameScene.swift
//  Life
//
//  Created by Олег Войтин on 04.07.2024.
//

import SpriteKit
import GameplayKit

import SpriteKit

class GameScene: SKScene {
    var cameraNode: SKCameraNode!
    var worldNode: SKNode!

    let worldSize: CGFloat = 1000
    let cameraMoveSpeed: CGFloat = 10.0

    override func didMove(to view: SKView) {
        setupWorld()
        setupCamera()
    }

    func setupWorld() {
        worldNode = SKNode()
        addChild(worldNode)

        // Создаем игровое поле из квадратов
        let numberOfSquares = 10
        let squareSize = worldSize / CGFloat(numberOfSquares)
        for i in 0..<numberOfSquares {
            for j in 0..<numberOfSquares {
                let squareNode = SKSpriteNode(color: .green, size: CGSize(width: squareSize, height: squareSize))
                squareNode.position = CGPoint(x: CGFloat(i) * squareSize - worldSize / 2, y: CGFloat(j) * squareSize - worldSize / 2)
                worldNode.addChild(squareNode)
            }
        }
    }

    func setupCamera() {
        cameraNode = SKCameraNode()
        camera = cameraNode
        addChild(cameraNode)
        cameraNode.position = CGPoint(x: 0, y: 0)
    }

    override func update(_ currentTime: TimeInterval) {
        handleCameraMovement()
        wrapCameraPosition()
    }

    func handleCameraMovement() {
        if let currentTouch = touches.first {
            let location = currentTouch.location(in: self.view)
            let moveVector = CGVector(dx: location.x - cameraNode.position.x, dy: location.y - cameraNode.position.y)
            cameraNode.position = CGPoint(x: cameraNode.position.x + moveVector.dx * cameraMoveSpeed * 0.01,
                                          y: cameraNode.position.y + moveVector.dy * cameraMoveSpeed * 0.01)
        }
    }

    func wrapCameraPosition() {
        var newPosition = cameraNode.position

        if cameraNode.position.x > worldSize / 2 {
            newPosition.x = -worldSize / 2
        } else if cameraNode.position.x < -worldSize / 2 {
            newPosition.x = worldSize / 2
        }

        if cameraNode.position.y > worldSize / 2 {
            newPosition.y = -worldSize / 2
        } else if cameraNode.position.y < -worldSize / 2 {
            newPosition.y = worldSize / 2
        }

        cameraNode.position = newPosition
    }

//    var touches: Set<NSTouch> = []
//
//    override func mouseDown(with event: NSEvent) {
//        let location = event.location(in: self)
//        let touch = NSTouch()
//        touch.setTouch(location)
//        touches.insert(touch)
//    }
//
//    override func mouseDragged(with event: NSEvent) {
//        let location = event.location(in: self)
//        let touch = NSTouch()
//        touch.setTouch(location)
//        touches.insert(touch)
//    }
//
//    override func mouseUp(with event: NSEvent) {
//        touches.removeAll()
//    }
//}
//
//extension NSTouch {
//    func setTouch(_ location: CGPoint) {
//        // Здесь можно добавить любую логику для настройки объекта NSTouch
//        // В данном случае достаточно просто назначить координаты касания
//        self.location = location
//    }
//}

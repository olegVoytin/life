//
//  CameraManager.swift
//  Life
//
//  Created by Олег Войтин on 04.07.2024.
//

import Foundation
import SpriteKit

@MainActor
protocol CameraManagerProtocol: AnyObject {
    var cameraNode: SKCameraNode { get }
}

@MainActor
final class CameraManager: CameraManagerProtocol {

    let cameraNode = SKCameraNode()

    private var lastPanTranslation: CGPoint?
    private var lastScale: CGFloat = 0

    @objc func handlePanGesture(_ gesture: NSPanGestureRecognizer) {
        let translation = gesture.translation(in: nil)

        switch gesture.state {
        case .began:
            lastPanTranslation = translation

        case .changed:
            if let lastTranslation = lastPanTranslation {
                // Учитываем масштаб камеры при вычислении дельты
                let scaleAdjustment = 1.0 / cameraNode.xScale
                let delta = CGPoint(
                    x: (translation.x - lastTranslation.x) / scaleAdjustment,
                    y: -(translation.y - lastTranslation.y) / scaleAdjustment
                )
                cameraNode.position = CGPoint(
                    x: cameraNode.position.x - delta.x,
                    y: cameraNode.position.y + delta.y
                )

                lastPanTranslation = translation
            }

        case .ended, .cancelled:
            lastPanTranslation = nil

        default:
            break
        }
    }

//    @objc func handleZoomGesture(_ gesture: NSPanGestureRecognizer) {
//        let animationDuration = 0.1
//
//        gesture.numberOfTouchesRequired = 2
//
//        switch gesture.state {
//        case .began, .changed:
//            let newScale = cameraNode.xScale / scale
//
//            if newScale < scaleMinimum {
//                let scaleAction = SKAction.scale(to: scaleMinimum, duration: animationDuration)
//                cameraNode.run(scaleAction)
//            } else if newScale > scaleMaximum {
//                let scaleAction = SKAction.scale(to: scaleMaximum, duration: animationDuration)
//                cameraNode.run(scaleAction)
//            } else {
//                cameraNode.setScale(newScale)
//            }
//
//            gesture.scale = 1.0
//
//        case .ended:
//            // Optional: Smooth transition back to within bounds if needed
//            if cameraNode.xScale < scaleMinimum {
//                let scaleAction = SKAction.scale(to: scaleMinimum, duration: animationDuration)
//                cameraNode.run(scaleAction)
//            } else if cameraNode.xScale > scaleMaximum {
//                let scaleAction = SKAction.scale(to: scaleMaximum, duration: animationDuration)
//                cameraNode.run(scaleAction)
//            }
//
//        default:
//            break
//        }
//    }
}

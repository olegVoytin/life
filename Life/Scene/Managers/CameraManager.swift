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

    @objc func handleZoomGesture(_ gesture: NSMagnificationGestureRecognizer) {
        // Применение экспоненциального масштабирования
        let magnificationFactor = 1.0 - gesture.magnification

        // Обновление масштаба камеры
        cameraNode.xScale *= magnificationFactor
        cameraNode.yScale *= magnificationFactor

        // Ограничение масштаба камеры (можно изменить по необходимости)
        cameraNode.xScale = max(0.1, min(20.0, cameraNode.xScale))
        cameraNode.yScale = max(0.1, min(20.0, cameraNode.yScale))

        // Сброс значения увеличения, чтобы учитывать только изменения
        gesture.magnification = 0
    }
}

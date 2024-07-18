//
//  Camera.swift
//  Life2
//
//  Created by Олег Войтин on 17.07.2024.
//

import Foundation
import Cocoa

extension GameViewController {
    
    func setupGestureRecognizers() {
        let panGestureRecognizer = NSPanGestureRecognizer(
            target: self,
            action: #selector(handlePanGesture(_:))
        )
        let zoomGestureRecognizer = NSMagnificationGestureRecognizer(
            target: self,
            action: #selector(handleZoomGesture(_:))
        )

        self.view.addGestureRecognizer(panGestureRecognizer)
        self.view.addGestureRecognizer(zoomGestureRecognizer)
    }

    @objc private func handlePanGesture(_ gesture: NSPanGestureRecognizer) {
        let translation = gesture.translation(in: nil)

        switch gesture.state {
        case .began:
            lastPanTranslation = translation

        case .changed:
            if let lastTranslation = lastPanTranslation {
                let delta = CGPoint(
                    x: (translation.x - lastTranslation.x) / CGFloat(cameraScale),
                    y: (translation.y - lastTranslation.y) / CGFloat(cameraScale)
                )

                cameraTranslation.x += Float(delta.x / view.frame.width) * 2
                cameraTranslation.y += Float(delta.y / view.frame.height) * 2

                lastPanTranslation = translation
            }

        case .ended, .cancelled:
            lastPanTranslation = nil

        default:
            break
        }
    }

    @objc private func handleZoomGesture(_ gesture: NSMagnificationGestureRecognizer) {
        let magnificationFactor = 1.0 + gesture.magnification

        // Scale the camera
        cameraScale *= Float(magnificationFactor)

        // Ограничение масштаба
        if cameraScale < 0.01 {
            cameraScale = 0.01
        } else if cameraScale > 20.0 {
            cameraScale = 20.0
        }

        gesture.magnification = 0
    }
}

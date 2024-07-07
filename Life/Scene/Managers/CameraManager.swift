//
//  CameraManager.swift
//  Life
//
//  Created by Олег Войтин on 04.07.2024.
//

import Foundation
import SpriteKit

@MainActor
final class CameraManager {

    private var lastPanTranslation: CGPoint?
    private var lastScale: CGFloat = 0

    let view: NSView

    init(view: NSView) {
        self.view = view
    }

    @objc func handlePanGesture(_ gesture: NSPanGestureRecognizer) {
        let translation = gesture.translation(in: nil)

        switch gesture.state {
        case .began:
            lastPanTranslation = translation

        case .changed:
            if let lastTranslation = lastPanTranslation {
                let delta = CGPoint(
                    x: translation.x - lastTranslation.x,
                    y: translation.y - lastTranslation.y
                )
                view.frame.origin = CGPoint(
                    x: view.frame.origin.x + delta.x,
                    y: view.frame.origin.y + delta.y
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
        let magnificationFactor = 1.0 + gesture.magnification

        view.scaleUnitSquare(to: CGSize(width: magnificationFactor, height: magnificationFactor))

        // Ограничение масштаба
        let scale = view.bounds.size.width / view.frame.size.width
        if scale < 0.1 || scale > 20.0 {
            view.scaleUnitSquare(to: CGSize(width: 1.0 / magnificationFactor, height: 1.0 / magnificationFactor))
        }

        gesture.magnification = 0
    }
}

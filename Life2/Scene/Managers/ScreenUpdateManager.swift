//
//  ScreenUpdateManager.swift
//  Life2
//
//  Created by Олег Войтин on 20.07.2024.
//

import Foundation
import Cocoa
import QuartzCore
import CoreVideo

@MainActor
protocol ScreenUpdateManagerProtocol {
    func startDisplayLink()
}

@MainActor
final class ScreenUpdateManager: ScreenUpdateManagerProtocol {

    private var displayLink: CVDisplayLink?

    private let displayLinkCallback: CVDisplayLinkOutputCallback = { (
        displayLink,
        inNow,
        inOutputTime,
        flagsIn,
        flagsOut,
        displayLinkContext
    ) -> CVReturn in
        let _self = Unmanaged<ScreenUpdateManager>.fromOpaque(displayLinkContext!).takeUnretainedValue()
        _self.displayLinkFired()
        return kCVReturnSuccess
    }

    private weak var scene: GameSceneProtocol?
    private let gridManager: GridManagerProtocol

    init(scene: GameSceneProtocol?, gridManager: GridManagerProtocol) {
        self.scene = scene
        self.gridManager = gridManager
    }

    deinit {
//        stopDisplayLink()
    }

    // MARK: - DisplayLink

    func startDisplayLink() {
        if displayLink == nil {
            setupDisplayLink()
        }

        if let displayLink = displayLink, !CVDisplayLinkIsRunning(displayLink) {
            CVDisplayLinkStart(displayLink)
        }
    }

    private func setupDisplayLink() {
        CVDisplayLinkCreateWithActiveCGDisplays(&displayLink)
        CVDisplayLinkSetOutputCallback(
            displayLink!,
            displayLinkCallback,
            UnsafeMutableRawPointer(Unmanaged.passUnretained(self).toOpaque())
        )
        CVDisplayLinkSetCurrentCGDisplay(displayLink!, CGMainDisplayID())
    }

    private func displayLinkFired() {
        
    }

    private func stopDisplayLink() {
        if let displayLink = displayLink, CVDisplayLinkIsRunning(displayLink) {
            CVDisplayLinkStop(displayLink)
        }
    }

    // MARK: - Screen Refresh

    private func updateChangedSquares() async {
        let changedSquaresFootprints = await gridManager.changedSquaresFootprints

        guard !changedSquaresFootprints.isEmpty else { return }

        Task { @MainActor in
            changedSquaresFootprints.forEach {
                scene?.changeColorOfSquare(
                    atRow: Int($0.position.y),
                    column: Int($0.position.x),
                    toColor: $0.color.vector
                )
            }
        }
    }
}

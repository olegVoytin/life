//
//  GameViewController.swift
//  Life
//
//  Created by Олег Войтин on 04.07.2024.
//

import Cocoa
import MetalKit

@MainActor
protocol GameSceneProtocol: AnyObject {
    func changeColorOfSquare(atRow row: Int, column: Int, toColor color: vector_float4)
}

class GameViewController: NSViewController, GameSceneProtocol {

    private let presenter = GameScenePresenter()

    var mtkView: MTKView!

    var device: MTLDevice!
    var commandQueue: MTLCommandQueue!
    var pipelineState: MTLRenderPipelineState!

    var vertexBuffer: MTLBuffer!
    var colorBuffer: MTLBuffer!
    var uniformBuffer: MTLBuffer!

    let vertexSize = MemoryLayout<vector_float2>.size
    let colorSize = MemoryLayout<vector_float4>.size

    var vertexData: [vector_float2] = []
    var colorData: [vector_float4] = []
    var transformMatrix = matrix_identity_float4x4

    var displayLink: CADisplayLink?

    var cameraScale: Float = 1.0
    var cameraTranslation: vector_float2 = [0, 0]
    var lastPanTranslation: CGPoint?

    override func viewDidLoad() {
        super.viewDidLoad()

        presenter.scene = self

        setupMetalView()
        generateGrid()
        setupGestureRecognizers()

        presenter.start()
    }

    func changeColorOfSquare(atRow row: Int, column: Int, toColor color: vector_float4) {
        // Ensure the row and column are within the valid range
        guard
            row >= 0,
            row < Constants.gridSide,
            column >= 0,
            column < Constants.gridSide
        else {
            print("Invalid row or column")
            return
        }

        // Each square has 6 vertices, so we need to update 6 color values
        let squareIndex = (row * Constants.gridSide + column) * 6

        for i in 0..<6 {
            // Update the color buffer
            colorBuffer.contents().storeBytes(
                of: color,
                toByteOffset: (squareIndex + i) * colorSize,
                as: vector_float4.self
            )
        }
    }
}

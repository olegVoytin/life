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

//    let cellCount = 4
    let vertexSize = MemoryLayout<vector_float2>.size
    let colorSize = MemoryLayout<vector_float4>.size

    var vertexData: [vector_float2] = []
    var colorData: [vector_float4] = []
    var transformMatrix = matrix_identity_float4x4

    var timer: Timer?

    var cameraScale: Float = 1.0
    var cameraTranslation: vector_float2 = [0, 0]
    var lastPanTranslation: CGPoint?

    override func viewDidLoad() {
        super.viewDidLoad()

        setupMetalView()
        generateGrid()
        setupGestureRecognizers()

        presenter.start()

        Task { @MainActor in
            while true {
                async let limit: ()? = try? await Task.sleep(for: .seconds(1))
                async let cycle: () = update()

                _ = await (
                    limit,
                    cycle
                )
            }
        }
    }

    func update() async {
        
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
            colorData[squareIndex + i] = color
        }

        // Update the color buffer
        colorBuffer.contents().copyMemory(from: colorData, byteCount: colorData.count * colorSize)
    }

//    func update() {
//        let randomColor = vector_float4(Float.random(in: 0...1), Float.random(in: 0...1), Float.random(in: 0...1), 1.0)
//        changeColorOfSquare(atRow: 3, column: 3, toColor: randomColor)
//    }
}

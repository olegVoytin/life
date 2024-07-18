//
//  MTKViewDelegate.swift
//  Life2
//
//  Created by Олег Войтин on 17.07.2024.
//

import Foundation
import MetalKit

extension GameViewController: MTKViewDelegate {

    func draw(in view: MTKView) {
        guard let drawable = view.currentDrawable, let descriptor = view.currentRenderPassDescriptor else {
            return
        }

        let commandBuffer = commandQueue.makeCommandBuffer()!
        let renderEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: descriptor)!

        renderEncoder.setRenderPipelineState(pipelineState)
        renderEncoder.setVertexBuffer(vertexBuffer, offset: 0, index: 0)
        renderEncoder.setVertexBuffer(colorBuffer, offset: 0, index: 1)

        // Set transformation for the camera
        var scaleMatrix = matrix_identity_float4x4
        scaleMatrix.columns.0.x = cameraScale
        scaleMatrix.columns.1.y = cameraScale

        var translationMatrix = matrix_identity_float4x4
        translationMatrix.columns.3.x = cameraTranslation.x
        translationMatrix.columns.3.y = cameraTranslation.y

        // Combine scale and translation matrices
        transformMatrix = matrix_multiply(scaleMatrix, translationMatrix)

        uniformBuffer.contents().copyMemory(from: &transformMatrix, byteCount: MemoryLayout<float4x4>.size)
        renderEncoder.setVertexBuffer(uniformBuffer, offset: 0, index: 2)

        renderEncoder.setVertexBytes(&transformMatrix, length: MemoryLayout.size(ofValue: transformMatrix), index: 2)

        // Change to draw primitives of type .triangle
        renderEncoder.drawPrimitives(type: .triangle, vertexStart: 0, vertexCount: vertexData.count)

        renderEncoder.endEncoding()
        commandBuffer.present(drawable)
        commandBuffer.commit()
    }

    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {}

    func setupMetalView() {
        mtkView = MTKView(frame: view.bounds)
        mtkView.device = MTLCreateSystemDefaultDevice()
        view.addSubview(mtkView)

        device = MTLCreateSystemDefaultDevice()
        mtkView.device = device
        mtkView.delegate = self

        commandQueue = device.makeCommandQueue()

        let library = device.makeDefaultLibrary()
        let vertexFunction = library?.makeFunction(name: "vertexShader")
        let fragmentFunction = library?.makeFunction(name: "fragmentShader")

        let pipelineDescriptor = MTLRenderPipelineDescriptor()
        pipelineDescriptor.vertexFunction = vertexFunction
        pipelineDescriptor.fragmentFunction = fragmentFunction
        pipelineDescriptor.colorAttachments[0].pixelFormat = mtkView.colorPixelFormat

        pipelineState = try! device.makeRenderPipelineState(descriptor: pipelineDescriptor)
    }

    func generateGrid() {
        for y in 0..<Constants.gridSide {
            for x in 0..<Constants.gridSide {
                let blockSide = Float(Constants.blockSide)
                let xPos = Float(x) / Float(Constants.gridSide) * blockSide - 1.0
                let yPos = Float(y) / Float(Constants.gridSide) * blockSide - 1.0
                let size = blockSide / Float(Constants.gridSide)

                let topLeft = vector_float2(xPos, yPos)
                let topRight = vector_float2(xPos + size, yPos)
                let bottomLeft = vector_float2(xPos, yPos + size)
                let bottomRight = vector_float2(xPos + size, yPos + size)

                // Defining the vertices for two triangles forming a square
                vertexData.append(contentsOf: [topLeft, bottomLeft, topRight, topRight, bottomLeft, bottomRight])

                let randomColor = vector_float4(0, 0, 0, 1.0)
                // Repeat the same color for all six vertices of the square
                colorData.append(contentsOf: [randomColor, randomColor, randomColor, randomColor, randomColor, randomColor])
            }
        }

        vertexBuffer = device.makeBuffer(bytes: vertexData, length: vertexData.count * vertexSize, options: [])
        colorBuffer = device.makeBuffer(bytes: colorData, length: colorData.count * colorSize, options: [])
        uniformBuffer = device.makeBuffer(length: MemoryLayout<float4x4>.size * 2, options: [])
    }
}

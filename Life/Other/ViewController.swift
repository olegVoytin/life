//
//  ViewController.swift
//  Life
//
//  Created by Олег Войтин on 04.07.2024.
//

import Cocoa
import SpriteKit

class ViewController: NSViewController {

    @IBOutlet var skView: NSView!
    private var cameraManager: CameraManager1!

    override func viewDidLoad() {
        super.viewDidLoad()

        cameraManager = CameraManager1(view: skView)

        let rows = 20
        let cols = 20
        let cellSize = CGSize(width: 10, height: 10)
        let automatonView = CellularAutomatonView(
            frame: self.skView.bounds,
            rows: rows,
            cols: cols,
            cellSize: cellSize
        )

        self.skView.addSubview(automatonView)

        setupGestureRecognizers()

        // Пример обновления клеток
        automatonView.updateCell(at: 0, col: 0, isAlive: true)
        automatonView.updateCell(at: 1, col: 1, isAlive: true)
    }

    private func setupGestureRecognizers() {
        let panGestureRecognizer = NSPanGestureRecognizer(target: cameraManager, action: #selector(cameraManager.handlePanGesture(_:)))
        let zoomGestureRecognizer = NSMagnificationGestureRecognizer(target: cameraManager, action: #selector(cameraManager.handleZoomGesture(_:)))

        self.view.addGestureRecognizer(panGestureRecognizer)
        self.view.addGestureRecognizer(zoomGestureRecognizer)
    }

    private func createScene() -> SKScene {
        let presenter = GameScenePresenter()
        let scene = GameScene(presenter: presenter)

        scene.scaleMode = .aspectFill
        scene.anchorPoint = CGPoint(x: 0, y: 0)

        presenter.scene = scene

        return scene
    }
}

class CellularAutomatonView: NSView {
    private var cellLayers: [[CALayer]] = []
    private let rows: Int
    private let cols: Int
    private let cellSize: CGSize

    init(frame: CGRect, rows: Int, cols: Int, cellSize: CGSize) {
        self.rows = rows
        self.cols = cols
        self.cellSize = cellSize
        super.init(frame: frame)

        // Включаем поддержку слоев у NSView
        self.wantsLayer = true
        setupLayers()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupLayers() {
        guard let rootLayer = self.layer else {
            return
        }

        for row in 0..<rows {
            var rowLayers: [CALayer] = []
            for col in 0..<cols {
                let layer = CALayer()
                layer.frame = CGRect(
                    x: CGFloat(col) * cellSize.width,
                    y: CGFloat(row) * cellSize.height,
                    width: cellSize.width,
                    height: cellSize.height
                )
                layer.backgroundColor = NSColor.gray.cgColor // или любой другой начальный цвет
                rootLayer.addSublayer(layer)
                rowLayers.append(layer)
            }
            cellLayers.append(rowLayers)
        }
    }

    func updateCell(at row: Int, col: Int, isAlive: Bool) {
        let color = isAlive ? NSColor.black.cgColor : NSColor.white.cgColor
        cellLayers[row][col].backgroundColor = color
    }
}

@MainActor
final class CameraManager1 {
    let view: NSView

    private var lastPanTranslation: CGPoint?
    private var lastScale: CGFloat = 0

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

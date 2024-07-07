//
//  GameViewController.swift
//  Life
//
//  Created by Олег Войтин on 04.07.2024.
//

import Cocoa
import SpriteKit

@MainActor
protocol GameSceneProtocol: AnyObject {
    func addGesture(_ gestureRecognizer: NSGestureRecognizer)
    func addSublayer(_ sublayer: CALayer)
}

class GameViewController: NSViewController, GameSceneProtocol {

    @IBOutlet var gameView: NSView!

    private let presenter = GameScenePresenter()
    private lazy var cameraManager = CameraManager(view: gameView)

    override func viewDidLoad() {
        super.viewDidLoad()

        presenter.scene = self
        presenter.start()

        let rows = 20
        let cols = 20
        let cellSize = CGSize(width: 10, height: 10)
        let automatonView = CellularAutomatonView(
            frame: self.gameView.bounds,
            rows: rows,
            cols: cols,
            cellSize: cellSize
        )

        self.gameView.addSubview(automatonView)

        setupGestureRecognizers()

        // Пример обновления клеток
        automatonView.updateCell(at: 0, col: 0, isAlive: true)
        automatonView.updateCell(at: 1, col: 1, isAlive: true)
    }

    private func setupGestureRecognizers() {
        let panGestureRecognizer = NSPanGestureRecognizer(
            target: cameraManager,
            action: #selector(cameraManager.handlePanGesture(_:))
        )
        let zoomGestureRecognizer = NSMagnificationGestureRecognizer(
            target: cameraManager,
            action: #selector(cameraManager.handleZoomGesture(_:))
        )

        self.view.addGestureRecognizer(panGestureRecognizer)
        self.view.addGestureRecognizer(zoomGestureRecognizer)
    }

    override func mouseDown(with event: NSEvent) {
//        let position = event.location(in: self)
//        presenter.onTap(position: position)
    }

    func addGesture(_ gestureRecognizer: NSGestureRecognizer) {
        self.gameView.addGestureRecognizer(gestureRecognizer)
    }

    func addSublayer(_ sublayer: CALayer) {
        self.gameView.layer?.addSublayer(sublayer)
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

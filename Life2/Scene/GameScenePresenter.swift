//
//  GameScenePresenter.swift
//  Life
//
//  Created by Олег Войтин on 04.07.2024.
//

import Foundation
import AppKit
import Cocoa
import QuartzCore
import CoreVideo

@globalActor
actor ProcessingActor {
    static let shared = ProcessingActor()
    private init() {}
}

@MainActor
protocol GameScenePresenterProtocol: AnyObject {
    func start()
    func onTap(position: CGPoint)
}

@MainActor
final class GameScenePresenter: GameScenePresenterProtocol {
    
    weak var scene: GameSceneProtocol?
    var displayLink: CVDisplayLink?

    @ProcessingActor private lazy var gridManager: GridManagerProtocol = GridManager()
    @ProcessingActor private lazy var cellsManager: CellsManagerProtocol = CellsManager(gridManager: gridManager)
    @ProcessingActor private lazy var cycleManager: CycleManagerProtocol = CycleManager(
        cellsManager: cellsManager,
        onCycleFinished: { [weak self] in
            self?.updateChangedSquares()
        }
    )

    // MARK: - Setup

    func start() {
        Task { @ProcessingActor in
            cycleManager.startCycle()

            for _ in 1...10000 {
                let randomX = Int.random(in: 0..<Constants.gridSide)
                let randomY = Int.random(in: 0..<Constants.gridSide)
                cellsManager.addCell(to: CGPoint(x: randomX, y: randomY))
            }
        }
    }

    @ProcessingActor
    private func updateChangedSquares() {
        let changedSquaresFootprints = gridManager.grid
            .flatMap { $0 }
            .filter { $0.changed }
            .map { $0.read() }

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

//    func setupDisplayLink() {
//        CVDisplayLinkCreateWithActiveCGDisplays(&displayLink)
//
//        let displayLinkOutputCallback: CVDisplayLinkOutputCallback = { (
//            displayLink: CVDisplayLink,
//            inNow: UnsafePointer<CVTimeStamp>,
//            inOutputTime: UnsafePointer<CVTimeStamp>,
//            flagsIn: CVOptionFlags,
//            flagsOut: UnsafeMutablePointer<CVOptionFlags>,
//            displayLinkContext: UnsafeMutableRawPointer?) -> CVReturn in
//
//            let appDelegate = Unmanaged<AppDelegate>.fromOpaque(displayLinkContext!).takeUnretainedValue()
//            DispatchQueue.main.async {
//                self.displayLinkDidRefresh()
//            }
//            return kCVReturnSuccess
//        }
//
//        CVDisplayLinkSetOutputCallback(displayLink!, displayLinkOutputCallback, UnsafeMutableRawPointer(Unmanaged.passUnretained(self).toOpaque()))
//        CVDisplayLinkStart(displayLink!)
//    }
//
//    func displayLinkDidRefresh() {
//        // Your code to update the display goes here
//        print("Display link refreshed")
//    }

    // MARK: - Actions

    func onTap(position: CGPoint) {
        Task { @ProcessingActor in
            let grid = gridManager.grid

            let gridPosition = position.toGridPosition()
            let x = Int(gridPosition.x)
            let y = Int(gridPosition.y)

            guard
                x >= 0,
                y >= 0,
                grid.count - 1 >= y,
                grid[y].count - 1 >= x
            else { return }

            let square = grid[y][x]
            square.setType(.cell(type: .cell))

            cellsManager.addCell(to: gridPosition)
        }
    }
}

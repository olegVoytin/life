//
//  CycleManager.swift
//  Life
//
//  Created by Олег Войтин on 05.07.2024.
//

import Foundation

@ProcessingActor
protocol CycleManagerProtocol {
    func startCycle()
    func setCycleSpeed(_ newSpeed: CycleManager.Speed)
    func onNewFrame()
}

@ProcessingActor
final class CycleManager: CycleManagerProtocol {

    enum Speed {
        case pause
        case slow
        case medium
        case fast
        case screenRate
        case max

        var limitDuration: Duration {
            switch self {
            case .pause, .max, .screenRate:
                return .zero

            case .slow:
                return .milliseconds(500)

            case .medium:
                return .milliseconds(100)

            case .fast:
                return .milliseconds(10)
            }
        }

        var isLimitNeeded: Bool {
            switch self {
            case .slow, .medium, .fast:
                return true

            default:
                return false
            }
        }
    }

    private var speed: Speed = .slow
    private var isRunning = true

    private var frameCicle: Task<Void, Never>?

    private let cellsManager: CellsManagerProtocol

    private var iterations = 0

    init(cellsManager: CellsManagerProtocol) {
        self.cellsManager = cellsManager
    }

    func startCycle() {
        Task { @ProcessingActor in
            while isRunning {
                doCycle()

                if speed != .max {
                    try? await Task.sleep(for: speed.limitDuration)
                }

                await Task.yield()
            }
        }

        Task { @ProcessingActor in
            while true {
                countIterations()
                try? await Task.sleep(for: .seconds(1))
            }
        }
    }

    private func countIterations() {
        print("Iterations count: \(iterations)")
        iterations = 0
    }

    private func doCycle() {
        iterations += 1
        cellsManager.update()
    }

    func setCycleSpeed(_ newSpeed: Speed) {
        let oldSpeed = speed

        switch newSpeed {
        case .slow, .medium, .fast, .max:
            switch oldSpeed {
            case .pause, .screenRate:
                isRunning = true
                startCycle()

            default:
                break
            }

        default:
            isRunning = false
        }

        speed = newSpeed
    }

    func onNewFrame() {
        guard
            speed == .screenRate,
            frameCicle == nil
        else { return }

        frameCicle = Task { @ProcessingActor [weak self] in
            guard let self else { return }
            self.doCycle()
            self.frameCicle = nil
        }
    }
}

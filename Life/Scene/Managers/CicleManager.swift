//
//  CicleManager.swift
//  Life
//
//  Created by Олег Войтин on 05.07.2024.
//

import Foundation

@ProcessingActor
protocol CicleManagerProtocol {
    func startCicle()
    func setCicleSpeed(_ newSpeed: CicleManager.Speed)
    func onNewFrame()
}

@ProcessingActor
final class CicleManager: CicleManagerProtocol {

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

    private let cellsManager: CellsManagerProtocol

    init(cellsManager: CellsManagerProtocol) {
        self.cellsManager = cellsManager
    }

    func startCicle() {
        Task { @ProcessingActor in
            while speed != .pause, speed != .screenRate {
                async let limit: ()? = speed.isLimitNeeded ? try? await Task.sleep(for: speed.limitDuration) : nil
                async let cicle: () = doCicle()

                _ = await (
                    limit,
                    cicle
                )
            }
        }
    }

    private func doCicle() {
        Task { @ProcessingActor in
            await cellsManager.update()
            await Task.yield()
        }
    }

    func setCicleSpeed(_ newSpeed: Speed) {
        switch newSpeed {
        case .slow, .medium, .fast, .max:
            switch speed {
            case .pause:
                startCicle()

            case .screenRate:
                startCicle()

            default:
                break
            }

        default:
            break
        }

        speed = newSpeed
    }

    func onNewFrame() {
        guard speed == .screenRate else { return }
        doCicle()
    }
}

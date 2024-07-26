//
//  CellObjects.swift
//  Life2
//
//  Created by Олег Войтин on 26.07.2024.
//

import Foundation

extension Cell {

    enum BirthDirection {
        case forward
        case left
        case right
    }

    // удалить Int если не нужно генерить рандомное направление
    enum Direction: Int {
        case up = 0, down, left, right
    }

    // удалить Int если не нужно генерить рандомный тип
    enum CellType: Int {
        case cell = 0
        case transport
        case energyGetter
        case organicGetter
        case leaf

        var wantEnergy: Bool {
            switch self {
            case .cell, .transport:
                return true

            default:
                return false
            }
        }
    }

    enum Action {
        case move
        case giveBirth
        case rotate
    }

    final class EnergyHolder {
        var aBuffer = 0
        var bBuffer = 0
        var energy: Int

        init(energy: Int) {
            self.energy = energy
        }

        func useBuffer(energyPhase: EnergyPhase) {
            switch energyPhase {
            case .a:
                let energy = aBuffer
                aBuffer = 0
                self.energy += energy

            case .b:
                let energy = bBuffer
                bBuffer = 0
                self.energy += energy
            }
        }

        func takeEnergy(_ energy: Int, energyPhase: EnergyPhase) {
            switch energyPhase {
            case .a:
                aBuffer += energy

            case .b:
                bBuffer += energy
            }
        }
    }
}

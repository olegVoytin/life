//
//  CellObjects.swift
//  Life2
//
//  Created by Олег Войтин on 26.07.2024.
//

import Foundation

extension Cell {
    
    // удалить Int если не нужно генерить рандомное направление
    enum Direction: Int {
        case up = 0, down, left, right
    }

    enum CellType {
        case cell
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

        func getEnergy(_ energy: Int, energyPhase: EnergyPhase) {
            switch energyPhase {
            case .a:
                aBuffer += energy

            case .b:
                bBuffer += energy
            }
        }
    }
}

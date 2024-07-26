//
//  CellHarvestDelegate.swift
//  Life2
//
//  Created by Олег Войтин on 21.07.2024.
//

import Foundation

@ProcessingActor
protocol CellHarvestDelegate: AnyObject {
    func harvestEnergy(_ cell: Cell)
    func harvestOrganic(_ cell: Cell)
    func harvestSol(_ cell: Cell)
}

extension CellsManager: CellHarvestDelegate {

    func harvestEnergy(_ cell: Cell) {
        let grid = gridManager.grid

        let x = Int(cell.gridPosition.x)
        let y = Int(cell.gridPosition.y)
        let square = grid[y, x]

        guard square.energyLevel > 0 else { return }

        square.energyLevel -= 1
        cell.energyHolder.energy += 1
    }

    func harvestOrganic(_ cell: Cell) {
        let grid = gridManager.grid

        let x = Int(cell.gridPosition.x)
        let y = Int(cell.gridPosition.y)
        let square = grid[y, x]

        guard square.organicLevel > 0 else { return }

        square.organicLevel -= 1
        cell.energyHolder.energy += 1
    }

    func harvestSol(_ cell: Cell) {
        cell.energyHolder.energy += 1
    }
}

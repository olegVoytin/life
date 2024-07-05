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
}

@ProcessingActor
final class CicleManager: CicleManagerProtocol {

    let gridManager: GridManagerProtocol
    let cellsManager: CellsManagerProtocol

    init(gridManager: GridManagerProtocol, cellsManager: CellsManagerProtocol) {
        self.gridManager = gridManager
        self.cellsManager = cellsManager

        cellsManager.setUpDelegates(
            cellPositionDelegate: self,
            cellBirthGivingDelegate: self
        )
    }

    func startCicle() {
        Task { @ProcessingActor in
            while true {
                async let limit: ()? = try? await Task.sleep(for: .seconds(0.5))

                async let work = Task { @ProcessingActor in
                    await cellsManager.update()
                    await Task.yield()
                }

                _ = await (
                    limit,
                    work
                )
            }
        }
    }
}

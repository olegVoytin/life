//
//  Cell.swift
//  Life
//
//  Created by Олег Войтин on 05.07.2024.
//

import Foundation
import GameplayKit

@ProcessingActor
final class Cell: Equatable, Identifiable, Hashable {

    private weak var cellMovementDelegate: CellMovementDelegate?
    private weak var cellBirthGivingDelegate: CellBirthGivingDelegate?
    private weak var cellHarvestDelegate: CellHarvestDelegate?
    private weak var cellDeathDelegate: CellDeathDelegate?

    let genomeReandomizer: GKRandomDistribution
    let genome: [[UInt8]]
    var activeGen: Int

    var gridPosition: GridPosition
    var energyHolder: EnergyHolder
    var type: CellType
    var lookingDirection: Direction = .up

    var forwardChild: Cell?
    var leftChild: Cell?
    var rightChild: Cell?
    weak var parentCell: Cell?

    init(
        type: CellType,
        cellMovementDelegate: CellMovementDelegate?,
        cellBirthGivingDelegate: CellBirthGivingDelegate?,
        cellHarvestDelegate: CellHarvestDelegate?,
        cellDeathDelegate: CellDeathDelegate?,
        gridPosition: GridPosition,
        energy: Int,
        genome: [[UInt8]]?,
        activeGen: Int?
    ) {
        self.type = type
        self.cellMovementDelegate = cellMovementDelegate
        self.cellBirthGivingDelegate = cellBirthGivingDelegate
        self.cellHarvestDelegate = cellHarvestDelegate
        self.cellDeathDelegate = cellDeathDelegate
        self.gridPosition = gridPosition
        self.energyHolder = EnergyHolder(energy: energy)

        let genomeReandomizer = GKRandomDistribution(lowestValue: 0, highestValue: 255)
        self.genomeReandomizer = genomeReandomizer

        if let genome {
            self.genome = genome
        } else {
            self.genome = createRandomGenome()
        }

        if let activeGen {
            self.activeGen = activeGen
        } else {
            self.activeGen = genomeReandomizer.nextInt() % 32
        }

        func createRandomGenome() -> [[UInt8]] {
            var grid: [[UInt8]] = []

            for _ in 0..<32 {
                var row: [UInt8] = []

                for _ in 0..<21 {
                    let col: UInt8 = UInt8(genomeReandomizer.nextInt())
                    row.append(col)
                }

                grid.append(row)
            }

            return grid
        }
    }

    func update(energyPhase: EnergyPhase) {
        energyHolder.useBuffer(energyPhase: energyPhase)

        energyHolder.energy -= 5

        harvestEnergy()

        if energyHolder.energy <= 0 {
            cellDeathDelegate?.death(self)
            return
        }

        readGenome()
        sendEnergy(energyPhase: energyPhase)
    }

    private func rotate(to newDirection: Direction) {
        let energyCost = 5
        guard energyHolder.energy >= energyCost else { return }

        lookingDirection = newDirection

        energyHolder.energy -= energyCost
    }

    // MARK: - Energy

    private func harvestEnergy() {
        switch type {
        case .energyGetter:
            cellHarvestDelegate?.harvestEnergy(self)

        case .organicGetter:
            cellHarvestDelegate?.harvestOrganic(self)

        case .leaf:
            cellHarvestDelegate?.harvestSol(self)

        default:
            break
        }
    }

    private func sendEnergy(energyPhase: EnergyPhase) {
        switch type {
        case .transport:
            var childrenCount = 0

            if let forwardChild, forwardChild.type.wantEnergy {
                childrenCount += 1
            }

            if let leftChild, leftChild.type.wantEnergy {
                childrenCount += 1
            }

            if let rightChild, rightChild.type.wantEnergy {
                childrenCount += 1
            }

            if childrenCount > 0 {
                let energyForChild = energyHolder.energy / childrenCount

                forwardChild?.energyHolder.takeEnergy(energyForChild, energyPhase: energyPhase)
                leftChild?.energyHolder.takeEnergy(energyForChild, energyPhase: energyPhase)
                rightChild?.energyHolder.takeEnergy(energyForChild, energyPhase: energyPhase)

                energyHolder.energy -= energyForChild * childrenCount
            } else if let parentCell {
                parentCell.energyHolder.takeEnergy(energyHolder.energy, energyPhase: energyPhase)
                energyHolder.energy = 0
            } else {
                cellDeathDelegate?.death(self)
            }

        case .energyGetter, .leaf, .organicGetter:
            guard let parentCell else {
                cellDeathDelegate?.death(self)
                return
            }
            parentCell.energyHolder.takeEnergy(energyHolder.energy, energyPhase: energyPhase)
            energyHolder.energy = 0

        case .cell:
            break
        }
    }

    // MARK: - Genome

    private func readGenome() {
        let gens = genome[activeGen]

        // левый отросток
        if gens[0].inRange(lowerBound: 0, upperBound: 63) {
            cellBirthGivingDelegate?.giveBirth(
                self,
                childType: .cell,
                birthDirection: .left,
                activeGen: Int(gens[0]) % 32
            )
        } else if gens[0].inRange(lowerBound: 64, upperBound: 75) {
            cellBirthGivingDelegate?.giveBirth(
                self,
                childType: .leaf,
                birthDirection: .left,
                activeGen: Int(gens[0]) % 32
            )
        } else if gens[0].inRange(lowerBound: 76, upperBound: 85) {
            cellBirthGivingDelegate?.giveBirth(
                self,
                childType: .energyGetter,
                birthDirection: .left,
                activeGen: Int(gens[0]) % 32
            )
        } else if gens[0].inRange(lowerBound: 86, upperBound: 95) {
            cellBirthGivingDelegate?.giveBirth(
                self,
                childType: .organicGetter,
                birthDirection: .left,
                activeGen: Int(gens[0]) % 32
            )
        }

        // передний отросток
        if gens[1].inRange(lowerBound: 0, upperBound: 63) {
            cellBirthGivingDelegate?.giveBirth(
                self,
                childType: .cell,
                birthDirection: .forward,
                activeGen: Int(gens[1]) % 32
            )
        } else if gens[1].inRange(lowerBound: 64, upperBound: 75) {
            cellBirthGivingDelegate?.giveBirth(
                self,
                childType: .leaf,
                birthDirection: .forward,
                activeGen: Int(gens[1]) % 32
            )
        } else if gens[1].inRange(lowerBound: 76, upperBound: 85) {
            cellBirthGivingDelegate?.giveBirth(
                self,
                childType: .energyGetter,
                birthDirection: .forward,
                activeGen: Int(gens[1]) % 32
            )
        } else if gens[1].inRange(lowerBound: 86, upperBound: 95) {
            cellBirthGivingDelegate?.giveBirth(
                self,
                childType: .organicGetter,
                birthDirection: .forward,
                activeGen: Int(gens[1]) % 32
            )
        }

        // правый отросток
        if gens[2].inRange(lowerBound: 0, upperBound: 63) {
            cellBirthGivingDelegate?.giveBirth(
                self,
                childType: .cell,
                birthDirection: .right,
                activeGen: Int(gens[2]) % 32
            )
        } else if gens[2].inRange(lowerBound: 64, upperBound: 75) {
            cellBirthGivingDelegate?.giveBirth(
                self,
                childType: .leaf,
                birthDirection: .right,
                activeGen: Int(gens[2]) % 32
            )
        } else if gens[2].inRange(lowerBound: 76, upperBound: 85) {
            cellBirthGivingDelegate?.giveBirth(
                self,
                childType: .energyGetter,
                birthDirection: .right,
                activeGen: Int(gens[2]) % 32
            )
        } else if gens[2].inRange(lowerBound: 86, upperBound: 95) {
            cellBirthGivingDelegate?.giveBirth(
                self,
                childType: .organicGetter,
                birthDirection: .right,
                activeGen: Int(gens[2]) % 32
            )
        }
    }

    // MARK: - Random

    let reandomizer = GKRandomDistribution(lowestValue: 0, highestValue: 4)

    private func doRandomAction() {
        guard case .cell = type else { return }

        let action = reandomizer.nextInt(upperBound: 2)

        switch action {
        case 0:
            guard let direction = Direction(rawValue: reandomizer.nextInt(upperBound: 4)) else { return }
            rotate(to: direction)

        case 1:
            giveBirthRandomly()

        default:
            break
        }
    }

    private func giveBirthRandomly() {
        let direction = reandomizer.nextInt(upperBound: 3)
        let cellType = reandomizer.nextInt()

        guard cellType != 1 else { return }

        switch direction {
        case 0:
            cellBirthGivingDelegate?.giveBirth(
                self,
                childType: Cell.CellType(rawValue: cellType)!,
                birthDirection: .forward, 
                activeGen: 0
            )

        case 1:
            cellBirthGivingDelegate?.giveBirth(
                self,
                childType: Cell.CellType(rawValue: cellType)!,
                birthDirection: .left,
                activeGen: 0
            )

        case 2:
            cellBirthGivingDelegate?.giveBirth(
                self,
                childType: Cell.CellType(rawValue: cellType)!,
                birthDirection: .right,
                activeGen: 0
            )

        default:
            break
        }
    }

    private func moveRandomly() {
        let energyCost = 10
        guard energyHolder.energy >= energyCost else { return }

        guard let direction = Direction(rawValue: reandomizer.nextInt()) else { return }

        switch direction {
        case .up:
            cellMovementDelegate?.move(self, direction: .up)

        case .down:
            cellMovementDelegate?.move(self, direction: .down)

        case .left:
            cellMovementDelegate?.move(self, direction: .left)

        case .right:
            cellMovementDelegate?.move(self, direction: .right)
        }

        energyHolder.energy -= energyCost
    }

    nonisolated static func == (lhs: Cell, rhs: Cell) -> Bool {
        lhs.id == rhs.id
    }

    nonisolated func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

extension UInt8 {

    func inRange(lowerBound: UInt8, upperBound: UInt8) -> Bool {
        return self >= lowerBound && self <= upperBound
    }
}

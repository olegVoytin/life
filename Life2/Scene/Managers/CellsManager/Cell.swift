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

    var gridPosition: CGPoint
    var energyHolder: EnergyHolder
    var type: CellType = .cell
    var lookingDirection: Direction = .up

    var forwardChild: Cell?
    var leftChild: Cell?
    var rightChild: Cell?
    weak var parentCell: Cell?

    init(
        cellMovementDelegate: CellMovementDelegate?,
        cellBirthGivingDelegate: CellBirthGivingDelegate?,
        cellHarvestDelegate: CellHarvestDelegate?,
        cellDeathDelegate: CellDeathDelegate?,
        gridPosition: CGPoint,
        energy: Int
    ) {
        self.cellMovementDelegate = cellMovementDelegate
        self.cellBirthGivingDelegate = cellBirthGivingDelegate
        self.cellHarvestDelegate = cellHarvestDelegate
        self.cellDeathDelegate = cellDeathDelegate
        self.gridPosition = gridPosition
        self.energyHolder = EnergyHolder(energy: energy)
    }

    func update(energyPhase: EnergyPhase) {
        energyHolder.useBuffer(energyPhase: energyPhase)

        energyHolder.energy -= 5

        harvestEnergy()

        if energyHolder.energy <= 0 {
            cellDeathDelegate?.death(self)
            return
        }

        doRandomAction()
        sendEnergy(energyPhase: energyPhase)
    }

    private func rotate(to newDirection: Direction) {
        let energyCost = 5
        guard energyHolder.energy >= energyCost else { return }

        lookingDirection = newDirection

        energyHolder.energy -= energyCost
    }

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

                forwardChild?.energyHolder.getEnergy(energyForChild, energyPhase: energyPhase)
                leftChild?.energyHolder.getEnergy(energyForChild, energyPhase: energyPhase)
                rightChild?.energyHolder.getEnergy(energyForChild, energyPhase: energyPhase)

                energyHolder.energy -= energyForChild * childrenCount
            } else if let parentCell {
                parentCell.energyHolder.getEnergy(energyHolder.energy, energyPhase: energyPhase)
                energyHolder.energy = 0
            } else {
                cellDeathDelegate?.death(self)
            }

        case .energyGetter, .leaf, .organicGetter:
            guard let parentCell else {
                cellDeathDelegate?.death(self)
                return
            }
            parentCell.energyHolder.getEnergy(energyHolder.energy, energyPhase: energyPhase)
            energyHolder.energy = 0

        case .cell:
            break
        }
    }

    // MARK: - Random

    let reandomizer = GKRandomDistribution(lowestValue: 0, highestValue: 4)

    private func doRandomAction() {
        guard case .cell = type else { return }

        let action = reandomizer.nextInt(upperBound: 2)

        switch action {
        case 0:
            guard let direction = Direction(rawValue: reandomizer.nextInt()) else { return }
            rotate(to: direction)

        case 1:
            giveBirthRandomly()

        default:
            break
        }
    }

    private func giveBirthRandomly() {
        let direction = reandomizer.nextInt(upperBound: 3)

        switch direction {
        case 0:
            cellBirthGivingDelegate?.giveBirthForward(self)

        case 1:
            cellBirthGivingDelegate?.giveBirthLeft(self)

        case 2:
            cellBirthGivingDelegate?.giveBirthRight(self)

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
            cellMovementDelegate?.moveUp(self)

        case .down:
            cellMovementDelegate?.moveDown(self)

        case .left:
            cellMovementDelegate?.moveLeft(self)

        case .right:
            cellMovementDelegate?.moveRight(self)
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

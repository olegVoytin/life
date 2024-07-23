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

    private weak var cellMovementDelegate: CellMovementDelegate?
    private weak var cellBirthGivingDelegate: CellBirthGivingDelegate?
    private weak var cellHarvestDelegate: CellHarvestDelegate?
    private weak var cellDeathDelegate: CellDeathDelegate?

    var gridPosition: CGPoint
    var energy: Int
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
        self.energy = energy
    }

    nonisolated static func == (lhs: Cell, rhs: Cell) -> Bool {
        lhs.id == rhs.id
    }

    nonisolated func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    func update() {
        harvestEnergy()
        doRandomAction()
        sendEnergy()

        energy -= 5

        if energy <= 0 {
            death()
        }
    }

    func death() {
        if let forwardChild {
            forwardChild.parentCell = nil
            self.forwardChild = nil
        }

        if let leftChild {
            leftChild.parentCell = nil
            self.leftChild = nil
        }

        if let rightChild {
            rightChild.parentCell = nil
            self.rightChild = nil
        }

        if let parentCell {
            if parentCell.forwardChild == self {
                parentCell.forwardChild = nil
            }

            if parentCell.leftChild == self {
                parentCell.leftChild = nil
            }

            if parentCell.rightChild == self {
                parentCell.rightChild = nil
            }
        }

        cellDeathDelegate?.death(self)
    }

    private func rotate(to newDirection: Direction) {
        let energyCost = 5
        guard energy >= energyCost else { return }

        lookingDirection = newDirection

        energy -= energyCost
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

    private func sendEnergy() {
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
                let energyForChild = energy / childrenCount
                forwardChild?.energy += energyForChild
                leftChild?.energy += energyForChild
                rightChild?.energy += energyForChild
                energy -= energyForChild * 3
            } else if let parentCell {
                parentCell.energy += energy
                energy = 0
            } else {
                death()
            }

        case .energyGetter, .leaf, .organicGetter:
            guard let parentCell else {
                death()
                return
            }
            parentCell.energy += energy
            energy = 0

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
        let energyCost = 10
        guard energy >= energyCost else { return }

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

        energy -= energyCost
    }

    private func moveRandomly() {
        let energyCost = 10
        guard energy >= energyCost else { return }

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

        energy -= energyCost
    }
}

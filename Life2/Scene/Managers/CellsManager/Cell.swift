//
//  Cell.swift
//  Life
//
//  Created by Олег Войтин on 05.07.2024.
//

import Foundation
import GameplayKit

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

    var gridPosition: CGPoint
    var energy: Int
    var type: CellType = .cell
    var lookingDirection: Direction = .up
    var children: [Cell] = []
    weak var parentCell: Cell?

    init(
        cellMovementDelegate: CellMovementDelegate?,
        cellBirthGivingDelegate: CellBirthGivingDelegate?,
        gridPosition: CGPoint,
        energy: Int
    ) {
        self.cellMovementDelegate = cellMovementDelegate
        self.cellBirthGivingDelegate = cellBirthGivingDelegate
        self.gridPosition = gridPosition
        self.energy = energy
    }

    nonisolated static func == (lhs: Cell, rhs: Cell) -> Bool {
        lhs.id == rhs.id
    }

    nonisolated func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    @ProcessingActor
    func update() {
        doRandomAction()
        sendEnergy()
    }

    private func rotate(to newDirection: Direction) {
        lookingDirection = newDirection
    }

    private func sendEnergy() {
        switch type {
        case .transport:
            let childrenWantedEnergy = children.filter { $0.type.wantEnergy }
            let energyToOneChild = energy / childrenWantedEnergy.count
            childrenWantedEnergy.forEach {
                $0.energy += energyToOneChild
                energy -= energyToOneChild
            }

        case .energyGetter, .leaf, .organicGetter:
            parentCell?.energy += energy
            energy = 0

        case .cell:
            break
        }
    }

    // MARK: - Random

    let reandomizer = GKRandomDistribution(lowestValue: 0, highestValue: 4)

    @ProcessingActor
    private func doRandomAction() {
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

    @ProcessingActor
    private func giveBirthRandomly() {
        switch type {
        case .cell:
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

        default:
            break
        }
    }

    @ProcessingActor
    private func moveRandomly() {
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
    }
}

//
//  CGPoint.swift
//  Life
//
//  Created by Олег Войтин on 05.07.2024.
//

import Foundation

extension CGPoint {

    func toGridPosition() -> GridPosition {
        let y = Int(floor(self.y / CGFloat(Constants.blockSide))) + (Constants.gridSide / 2)
        let x = Int(floor(self.x / CGFloat(Constants.blockSide))) + (Constants.gridSide / 2)
        return GridPosition(x: x, y: y)
    }

    func fromGridPosition() -> CGPoint {
        let x = (Int(self.x) - (Constants.gridSide / 2)) * Constants.blockSide
        let y = (Int(self.y) - (Constants.gridSide / 2)) * Constants.blockSide
        return CGPoint(x: x, y: y)
    }
}

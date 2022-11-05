//
//  Enums.swift
//  SnakeSpriteKit
//
//  Created by Yura on 30.10.2022.
//

import Foundation


enum Direction {
    case right
    case left
    case up
    case down
    
    func getVector(step: CGFloat) -> CGVector {
        var dx: CGFloat = 0
        var dy: CGFloat = 0
        switch self {
        case .right:
            dx = step
        case .left:
            dx = -step
        case .up:
            dy = step
        case .down:
            dy = -step
        }
        return CGVector(dx: dx, dy: dy)
    }
    
    func getVectorToInfinite() -> CGVector {
        return getVector(step: Consts.veryLarge)
    }
    

}

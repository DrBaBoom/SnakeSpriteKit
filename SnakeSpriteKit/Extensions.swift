//
//  Extentions.swift
//  SnakeSpriteKit
//
//  Created by Yura on 30.10.2022.
//

import Foundation


extension CGPoint {
    static func +(lhr: CGPoint, vect: CGVector) -> CGPoint {
        return CGPoint(x: lhr.x + vect.dx, y: lhr.y + vect.dy)
    }
    
    func getDistance(to point: CGPoint) -> CGFloat {
        if (point.x == self.x) {
            return abs(point.y - self.y)
        } else {
            return abs(point.x - self.x)
        }
    }
}

infix operator ~
infix operator !~

extension CGFloat {
    static func ~(lhr: CGFloat, rhs: CGFloat) -> Bool {
        let mistake = 1.0
        return abs(lhr - rhs) <= mistake
    }
    
    static func !~(lhr: CGFloat, rhs: CGFloat) -> Bool {
        return !(lhr ~ rhs)
    }
}

extension CGPoint {
    static func ~(lhr: CGPoint, rhs: CGPoint) -> Bool {
        let mistake = 0.2
        return abs(lhr.x - rhs.x) <= mistake && abs(lhr.y - rhs.y) <= mistake
    }
    
    static func !~(lhr: CGPoint, rhs: CGPoint) -> Bool {
        return !(lhr ~ rhs)
    }
}

//
//  Square.swift
//  SnakeSpriteKit
//
//  Created by Yura on 30.10.2022.
//

import SpriteKit

class Square: SKSpriteNode {
    
    private(set) var direction: Direction = .up
    var previous: Square? = nil
    
    var isMoving = false

        
    init(size: CGSize) {
        super.init(texture: nil, color: .red, size: size)
        self.zPosition = 100
        self.name = "square"
        createPhysicsBody()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func mMoveAction(by direction: Direction) -> SKAction {
        self.direction = direction
        let currentPos = self.position
        let pointToMove: CGPoint
        switch direction {
        case .right:
            pointToMove = CGPoint(x: currentPos.x + Consts.veryLarge, y: currentPos.y)
        case .left:
            pointToMove = CGPoint(x: currentPos.x - Consts.veryLarge, y: currentPos.y)
        case .up:
            pointToMove = CGPoint(x: currentPos.x, y: currentPos.y + Consts.veryLarge)
        case .down:
            pointToMove = CGPoint(x: currentPos.x, y: currentPos.y - Consts.veryLarge)
        }
        let action = SKAction.move(to: pointToMove, duration: Consts.veryLarge / Consts.speed)
        return action
    }
    
    
    func turnIfNeeded() {
        if let previous = previous, previous.direction != self.direction {
            var changeDirection = false
            switch previous.direction {
            case .right, .left:
                changeDirection = self.position.y ~ previous.position.y
            case .down, .up:
                changeDirection = self.position.x ~ previous.position.x
            }
            if changeDirection {
                self.removeAllActions()
                self.run(mMoveAction(by: previous.direction))
            }
            
        }
    }
    
    func adjustMyPosition() {
        
        if let previous = previous, isMoving, direction == previous.direction {
            
            var needsAdjusting = false
            switch direction {
            case .right, .left:
                needsAdjusting = self.position.y ~ previous.position.y
            case .up, .down:
                needsAdjusting = self.position.x ~ previous.position.x
            }
            if !needsAdjusting {
                return
            }
            
            let w = self.size.width
            var x = previous.position.x
            var y = previous.position.y

            switch direction {
            case .right:
                x -= w
            case .left:
                x += w
            case .up:
                y -= w
            case .down:
                y += w
            }
            let newPos = CGPoint(x: x, y: y)
            if self.position !~ newPos {
                self.removeAllActions()
                let a1 = SKAction.move(to: newPos, duration: 0)
                let a2 = self.mMoveAction(by: direction)
                self.run(SKAction.sequence([a1, a2]))
            }
        }
    }
    
    func set(direction: Direction) {
        self.direction = direction
    }
    
    
    
    private func getDistance(point: CGPoint) -> CGFloat {
        if (point.x == self.position.x) {
            return abs(point.y - self.position.y)
        } else {
            return abs(point.x - self.position.x)
        }
    }
    
    
    func createPhysicsBody() {
        
    }
    
}

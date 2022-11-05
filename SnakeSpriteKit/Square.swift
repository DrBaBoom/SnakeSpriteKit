//
//  Square.swift
//  SnakeSpriteKit
//
//  Created by Yura on 30.10.2022.
//

import SpriteKit

class Square: SKSpriteNode {
    
    //    private(set) var direction: Direction = .up
    var previous: Square? = nil
    
    var pointOfDestination: CGPoint? {
        pointsToMove.first
    }
    
    fileprivate var pointsToMove = [CGPoint]()
    
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
    
    func addNewPoint(_ point: CGPoint) {
        pointsToMove.append(point)
    }
    
    func replaceLastPoint(_ point: CGPoint) {
        guard pointsToMove.count > 0 else {
            fatalError("Empty pointsToMove in replaceLastPoint")
        }
        pointsToMove[pointsToMove.count - 1] = point
    }
    
    func myPrint() { print() }
    
    func hasTwoPointsToMove() -> Bool {
        return pointsToMove.count == 2
    }
    
    
    func getPoint(by direction: Direction) -> CGPoint {
        //        self.direction = direction
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
        return pointToMove
    }
    
    func startMoving() {
        guard pointsToMove.count > 0 else {
            fatalError("Empty pointsToMove in startMoving")
        }
        let position = self.position
        let distance = abs((pointsToMove[0].x - position.x) + (pointsToMove[0].y - position.y))
        let moveAction = SKAction.move(to: pointsToMove[0], duration: distance / Consts.speed)
        self.run(moveAction) {
            self.pointsToMove.remove(at: 0)
            self.startMoving()
        }
    }
    
    func copyPointsToMove() {
        if let previous = previous {
            self.pointsToMove = previous.pointsToMove
        }
    }
    
    
    //    func mMoveAction(by direction: Direction) -> SKAction {
    //        self.direction = direction
    //        let currentPos = self.position
    //        let pointToMove: CGPoint
    //        switch direction {
    //        case .right:
    //            pointToMove = CGPoint(x: currentPos.x + Consts.veryLarge, y: currentPos.y)
    //        case .left:
    //            pointToMove = CGPoint(x: currentPos.x - Consts.veryLarge, y: currentPos.y)
    //        case .up:
    //            pointToMove = CGPoint(x: currentPos.x, y: currentPos.y + Consts.veryLarge)
    //        case .down:
    //            pointToMove = CGPoint(x: currentPos.x, y: currentPos.y - Consts.veryLarge)
    //        }
    //        let action = SKAction.move(to: pointToMove, duration: Consts.veryLarge / Consts.speed)
    //        return action
    //    }
    //
    
    //    func turnIfNeeded() {
    //        if let previous = previous, previous.direction != self.direction {
    //            var changeDirection = false
    //            switch previous.direction {
    //            case .right, .left:
    //                changeDirection = self.position.y ~ previous.position.y
    //            case .down, .up:
    //                changeDirection = self.position.x ~ previous.position.x
    //            }
    //            if changeDirection {
    //                self.removeAllActions()
    //                self.run(mMoveAction(by: previous.direction))
    //            }
    //
    //        }
    //    }
    
    func adjustMyPosition() {
        
        if let previous = previous, isMoving, pointOfDestination == previous.pointOfDestination {
            
            //            var needsAdjusting = false
            //            switch direction {
            //            case .right, .left:
            //                needsAdjusting = self.position.y ~ previous.position.y
            //            case .up, .down:
            //                needsAdjusting = self.position.x ~ previous.position.x
            //            }
            //            if !needsAdjusting {
            //                return
            //            }
            
            let position = self.position
            let destination = self.pointOfDestination!
            
            var direction = Direction.up
            let err: CGFloat = 2
            if destination.x - position.x > err {
                direction = .right
            } else if destination.x - position.x < -err {
                direction = .left
            } else if destination.y - position.y > err {
                direction = .up
            } else if destination.y - position.y < -err {
                direction = .down
            }
            
            let w = self.size.width + 1
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
                self.position = newPos
                self.removeAllActions()
                self.startMoving()
            }
            //
            //
            //                let a1 = SKAction.move(to: newPos, duration: 0)
            //                let a2 = self.mMoveAction(by: direction)
            //                self.run(SKAction.sequence([a1, a2]))
            //            }
        }
    }
    
    //    func set(direction: Direction) {
    //        self.direction = direction
    //    }
    
    
    
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




class HeadSquare: Square {
    
    var currentDirection: Direction = .up
    
    override func createPhysicsBody() {
        self.physicsBody = SKPhysicsBody(rectangleOf: self.size)
        self.physicsBody?.isDynamic = false
        self.physicsBody?.categoryBitMask = BitMasks.head
        self.physicsBody?.collisionBitMask = BitMasks.apple | BitMasks.body | BitMasks.wall
        self.physicsBody?.contactTestBitMask = BitMasks.apple | BitMasks.body | BitMasks.wall
    }
    
    
}

class NeckSquare: Square {
    
    override func createPhysicsBody() {
        self.physicsBody = SKPhysicsBody(rectangleOf: self.size)
        self.physicsBody?.isDynamic = false
        self.physicsBody?.categoryBitMask = BitMasks.neck
    }
}


class BodySquare: Square {
    
    override func createPhysicsBody() {
        self.physicsBody = SKPhysicsBody(rectangleOf: self.size)
        self.physicsBody?.isDynamic = false
        self.physicsBody?.categoryBitMask = BitMasks.body
    }
    
    override func myPrint() {
        for p in pointsToMove {
            print(p, terminator: ", ")
        }
        print()
    }
    
    
}

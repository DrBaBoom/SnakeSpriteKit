//
//  HeadSquare.swift
//  SnakeSpriteKit
//
//  Created by Yura on 01.11.2022.
//

import SpriteKit

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
    
    
}

//
//  Apple.swift
//  SnakeSpriteKit
//
//  Created by Yura on 30.10.2022.
//

import SpriteKit

class Apple: SKSpriteNode {
    
    func blow() {
        let grawUpAction = SKAction.scale(to: 1.2, duration: 0.3)
        let grawDownAction = SKAction.scale(to: 1, duration: 1)
        let sequence = SKAction.sequence([grawUpAction, grawDownAction])
        let repeatForever = SKAction.repeatForever(sequence)
        self.run(repeatForever)
    }
}

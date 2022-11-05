//
//  GameScene.swift
//  SnakeSpriteKit
//
//  Created by Yura on 30.10.2022.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var squareSize: CGSize!
    var head: HeadSquare!
    var snake: [Square] = []

    var waitAction: SKAction!
    
    override func didMove(to view: SKView) {
        
        physicsWorld.contactDelegate = self
        physicsWorld.gravity = .zero
        
        let directions: [UISwipeGestureRecognizer.Direction] = [.down, .up, .left, .right]
        for dir in directions {
            let swipe = UISwipeGestureRecognizer(target: self, action: #selector(self.swipe))
            swipe.direction = dir
            self.view?.addGestureRecognizer(swipe)
        }
        spawnManyApples()
        
        squareSize = CGSize(width: self.size.width / 20, height: self.size.width / 20)
        waitAction = SKAction.wait(forDuration: squareSize.width / Consts.speed)
        
        spawnNewSquare()

    }
    
    @objc func swipe(sender: UISwipeGestureRecognizer?) {
        if let swipeGesture = sender {
            var direction: Direction? = nil
            switch swipeGesture.direction {
            case UISwipeGestureRecognizer.Direction.right: direction = Direction.right
            case UISwipeGestureRecognizer.Direction.left: direction = Direction.left
            case UISwipeGestureRecognizer.Direction.up: direction = Direction.up
            case UISwipeGestureRecognizer.Direction.down: direction = Direction.down
            default: break
            }
            if let direction = direction {
                head.run(head.mMoveAction(by: direction))
            }
        }
    }
    
    func spawnNewSquare() {
        let newSquare = snake.count == 0 ? HeadSquare(size: squareSize) : ( snake.count == 1 ? NeckSquare(size: squareSize) : BodySquare(size: squareSize))
        if let head = newSquare as? HeadSquare {
            self.head = head
        }
        let position = snake.last?.position ?? CGPoint(x: self.size.width / 2, y: self.size.height / 2)
        let direction = snake.last?.direction ?? .up
        newSquare.previous = snake.last
        newSquare.position = position
        snake.append(newSquare)
        self.addChild(newSquare)
        let moveAction = newSquare.mMoveAction(by: direction)
        newSquare.run(waitAction) {
            newSquare.isMoving = true
            newSquare.run(moveAction)
        }
    }
    
    func spawnManyApples() {
        let spownActiont = SKAction.run {
            let apple = Apple()
            apple.texture = SKTexture(imageNamed: "apple")
            let randX = Int.random(in: 10...(Int(self.view!.bounds.size.width) - 10))
            let randY = Int.random(in: 10...(Int(self.view!.bounds.size.height) - 10))
            apple.position = CGPoint(x: randX, y: randY)
            apple.size = CGSize(width: self.size.width / 25, height: self.size.width / 25)
            apple.zPosition = 5
            apple.name = "apple"
    
            apple.physicsBody = SKPhysicsBody(rectangleOf: apple.size)
            apple.physicsBody?.isDynamic = true
            apple.physicsBody?.categoryBitMask = BitMasks.apple
            apple.physicsBody?.collisionBitMask = BitMasks.head
            apple.physicsBody?.contactTestBitMask = BitMasks.head
            self.addChild(apple)
            apple.blow()
        }
        let wait = SKAction.wait(forDuration: 1)
        
        let sequence = SKAction.sequence([wait, spownActiont])
        let repeatForever = SKAction.repeatForever(sequence)
        self.run(repeatForever)
    }
    
    override func update(_ currentTime: TimeInterval) {
        for s in snake {
            s.turnIfNeeded()
            s.adjustMyPosition()
        }
    }
}


extension GameScene: SKPhysicsContactDelegate {
    
    func didBegin(_ contact: SKPhysicsContact) {
        let colisionMask =  contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        if BitMasks.head | BitMasks.apple == colisionMask {
            if let appleNode = contact.bodyA.categoryBitMask & BitMasks.apple > 0 ? contact.bodyA.node : contact.bodyB.node, let apple = appleNode as? Apple {
                spawnNewSquare()

                let squash = SKEmitterNode(fileNamed: "Squash")
                squash?.position = apple.position
                zPosition = 10
                let waitSquash = SKAction.wait(forDuration: 1)
                addChild(squash!)
                apple.removeFromParent()
                self.run(waitSquash, completion: {
                    squash?.removeFromParent()
                })
            }

        }
    }
    
    func createWalls() {
//        let wall1 = SKSprite
//        wall1.frame = CGRect(x: <#T##CGFloat#>, y: <#T##CGFloat#>, width: <#T##CGFloat#>, height: <#T##CGFloat#>)
    }

    
}


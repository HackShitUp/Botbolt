//
//  MainScene.swift
//  Go Nano
//
//  Created by Joshua Choi on 5/1/19.
//  Copyright © 2019 Nanogram LLC. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit


/**
 Abstract: The main game interface
 
 - NOTE: Sprite Kit uses a coordinate orientation that starts from the bottom left corner of the scene (0,0), and the values increase as you move to the right (increasing x) and up (increasing y).
 */
class GameScene: SKScene {
    
    // MARK: - Class Vars
    
    var backgroundNode: BackgroundNode!
    var scoreNode: ScoreNode!
    var playerNode: PlayerNode!
    var leftControlNode: ControlNode!
    var rightControlNode: ControlNode!
    var actionControlNode: ControlNode!
    
    /// MARK: - Timer (used to auto-spawn enemies)
    var timer: Timer!
    
    // MARK: - UInt32
    let enemyCategory: UInt32 = 0x1 << 1
    let photonCategory: UInt32 = 0x1 << 0
    
    // MARK: - Init
    override init(size: CGSize) {
        super.init(size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: - SKScene Life Cycle
    override func didMove(to view: SKView) {
        
        // Play the background music
        run(SKAction.playSoundFileNamed("rollingstone8bit", waitForCompletion: false))
        
        // MARK: - Timer
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(spawnEnemies(_:)), userInfo: nil, repeats: true)
        
        // Self
        // Set the background color
        isUserInteractionEnabled = true
        backgroundColor = .black
        
        // MARK: - SKPhysicsWorld
        physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        physicsWorld.contactDelegate = self
        
        // MARK: - BackgroundNode
        backgroundNode = BackgroundNode()
        backgroundNode.position = CGPoint(x: size.width/2, y: size.height/2)
        backgroundNode.zPosition = -1
        addChild(backgroundNode)
        
        // MARK: - ScoreNode
        scoreNode = ScoreNode(fontNamed: "AvenirNext-Heavy")
        scoreNode.position = CGPoint(x: size.width/2, y: size.height - 40)
        scoreNode.fontSize = 30
        scoreNode.fontColor = UIColor.white
        scoreNode.score = 0
        addChild(scoreNode)
        
        // MARK: - ControlNode
        leftControlNode = ControlNode(.left, self)
        leftControlNode.setScale(0.20)
        leftControlNode.position = CGPoint(x: leftControlNode.size.width, y: 60)
        addChild(leftControlNode)
        
        // MARK: - ControlNode
        rightControlNode = ControlNode(.right, self)
        rightControlNode.setScale(0.20)
        rightControlNode.position = CGPoint(x: leftControlNode.position.x * 2 + 40, y: 60)
        addChild(rightControlNode)
        
        // MARK: - ControlNode
        actionControlNode = ControlNode(.fire, self)
        actionControlNode.setScale(0.20)
        actionControlNode.position = CGPoint(x: size.width - actionControlNode.size.width, y: 60)
        addChild(actionControlNode)
        
        // MARK: - PlayerNode
        playerNode = PlayerNode()
        playerNode.position = CGPoint(x: size.width/2, y: actionControlNode.position.y * 3)
        playerNode.physicsBody = SKPhysicsBody(rectangleOf: playerNode.size)
        playerNode.physicsBody?.isDynamic = true
        playerNode.physicsBody?.categoryBitMask = photonCategory
        playerNode.physicsBody?.contactTestBitMask = enemyCategory
        playerNode.physicsBody?.collisionBitMask = 0
        playerNode.physicsBody?.usesPreciseCollisionDetection = true
        addChild(playerNode)
        
        // Make the player node
        let jumpInPlaceAction = SKAction.sequence([
            SKAction.moveTo(y: CGFloat(playerNode.position.y + 8.0), duration: 0.2),
            SKAction.moveTo(y: CGFloat(playerNode.position.y - 8.0), duration: 0.2)
            ])
        playerNode.run(SKAction.repeatForever(jumpInPlaceAction))

    }
    
    /// Called to spawn enemies at scheduled time intervals
    /// - Parameter sender: Any object that calls this method.
    @objc func spawnEnemies(_ sender: Any) {
        // Setup the fireballs
        // MARK: - SKSpriteNode
        let enemyNode = SKSpriteNode(imageNamed: "Sea")
        enemyNode.setScale(0.4)
        enemyNode.physicsBody = SKPhysicsBody(rectangleOf: enemyNode.size)
        enemyNode.physicsBody?.isDynamic = true
        enemyNode.physicsBody?.categoryBitMask = enemyCategory
        enemyNode.physicsBody?.contactTestBitMask = photonCategory
        enemyNode.physicsBody?.collisionBitMask = 0
        addChild(enemyNode)
        
        // Generate a random position for the enemies to spawn
        let randomPosition = GKRandomDistribution(lowestValue: 0, highestValue: 818)
        let position = CGFloat(randomPosition.nextInt())
        enemyNode.position = CGPoint(x: position, y: size.height + playerNode.size.height + 16)
        
        // MARK: - SKAction
        // Execute the actions in sequence
        var actions = [SKAction]()
        actions.append(SKAction.move(to: CGPoint(x: position, y: -enemyNode.size.height), duration: 6))
        actions.append(SKAction.removeFromParent())
        enemyNode.run(SKAction.sequence(actions))
    }
    
    /// Move the main character to the left
    /// - Parameter sender: Any object that calls this method
    @objc fileprivate func moveLeft(_ sender: Any) {
        if playerNode.position.x >= 8 + playerNode.size.width {
            playerNode.run(SKAction.moveTo(x: CGFloat(playerNode.position.x - 16), duration: 0.1))
        }
    }
    
    /// Move the main character to the right
    /// - Parameter sender: Any object that calls this method
    @objc fileprivate func moveRight(_ sender: Any) {
        if playerNode.position.x <= size.width - 8 - playerNode.size.width {
            playerNode.run(SKAction.moveTo(x: CGFloat(playerNode.position.x + 16), duration: 0.1))
        }
    }
    
    /// Allows the main character sprite to attack with sparks.
    /// - Parameter sender: Any object that calls this method.
    @objc fileprivate func fire(_ sender: Any) {
        /**
         Logic:
         1. Create action to move sprite.
         2. Create action to remove sprite.
         3. Chain sequence of actions.
         */
        run(SKAction.playSoundFileNamed("wand", waitForCompletion: false))

        // MARK: - SKSpriteNode
        let sparkNode = SKSpriteNode(imageNamed: "Lightning")
        sparkNode.alpha = 0.01
        sparkNode.setScale(1)
        sparkNode.position = playerNode.position
        sparkNode.physicsBody = SKPhysicsBody(circleOfRadius: sparkNode.size.width/2)
        sparkNode.physicsBody?.isDynamic = true
        sparkNode.physicsBody?.categoryBitMask = photonCategory
        sparkNode.physicsBody?.contactTestBitMask = enemyCategory
        sparkNode.physicsBody?.collisionBitMask = 0
        sparkNode.physicsBody?.usesPreciseCollisionDetection = true
        addChild(sparkNode)
        
        // MARK: - SKEmitterNode
        let sparkEmitterNode = SKEmitterNode(fileNamed: "Spark")!
        sparkEmitterNode.position = playerNode.position
        sparkEmitterNode.setScale(0.10)
        sparkNode.zPosition = 1
        addChild(sparkEmitterNode)
        
        // MARK: - SKAction
        let attackActionSequence = SKAction.sequence([SKAction.moveTo(y: size.height, duration: 1), SKAction.removeFromParent()])
        sparkNode.run(attackActionSequence)
        sparkEmitterNode.run(attackActionSequence)
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("FIRED HERE!")
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("FIRED THERE!")
    }
}



// MARK: - ControlNodeDelegate
extension GameScene: ControlNodeDelegate {
    func tappedControl(_ control: ControlNode) {
        print("FIRED!")
        switch control.type {
        case .left?:
            moveLeft(self)
        case .right?:
            moveRight(self)
        case .fire?:
            fire(self)
        default:
            break;
        }
    }
}



// MARK: - SKPhysicsContactDelegate
extension GameScene: SKPhysicsContactDelegate {
    func didBegin(_ contact: SKPhysicsContact) {
        guard contact.bodyA.node != nil && contact.bodyB.node != nil else {
            return
        }
        
        if contact.bodyA.node == playerNode || contact.bodyB.node == playerNode {
            scoreNode.score -= 5
            
            // Explosion
            let explosion = SKEmitterNode(fileNamed: "Explosion")!
            explosion.position = playerNode.position
            addChild(explosion)
            
        } else if contact.bodyA.categoryBitMask == photonCategory || contact.bodyB.categoryBitMask == photonCategory {
            // Play the sound file
            run(SKAction.playSoundFileNamed("explosion", waitForCompletion: false))
            
            // Explosion
            let explosion = SKEmitterNode(fileNamed: "Explosion")!
            explosion.position = contact.bodyA.node!.position
            addChild(explosion)
            contact.bodyA.node!.removeFromParent()
            contact.bodyB.node!.removeFromParent()
            
            self.run(SKAction.wait(forDuration: 2)) {
                explosion.removeFromParent()
            }
            
            // MARK: - ScoreNode
            scoreNode.score += 5
        }
    }
    
}


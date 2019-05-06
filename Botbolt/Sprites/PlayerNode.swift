
//
//  PlayerNode.swift
//  Botbolt
//
//  Created by Joshua Choi on 5/5/19.
//  Copyright © 2019 Nanogram LLC. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

/**
 Abstract: Custom SKSpriteNode object representing the main character for the player.
 */
class PlayerNode: SKSpriteNode {

    /// MARK: - Init
    convenience init() {
        self.init(imageNamed: "Bot")
        self.setScale(0.40)

        // MARK: - SKEmitterNode
        let fireNode = SKEmitterNode(fileNamed: "Fire")!
        fireNode.setScale(0.5)
        fireNode.position = self.position
        fireNode.position.y = self.position.y
        fireNode.run(SKAction.rotate(byAngle: CGFloat(Double.pi/4), duration: 0))
        addChild(fireNode)
    }
}


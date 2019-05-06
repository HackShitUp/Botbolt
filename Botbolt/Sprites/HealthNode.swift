//
//  HealthNode.swift
//  Botbolt
//
//  Created by Joshua Choi on 5/6/19.
//  Copyright © 2019 Nanogram LLC. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

/**
 Abstract: Custom SpriteNode used to manage the current player's health.
 */
class HealthNode: SKSpriteNode {
    // MARK: - Class Vars
    
    /// Initialized Boolean value determining whether this health node is active or not. Defaults to TRUE.
    var isActive: Bool = true {
        didSet {
            // Run the action
            self.run(SKAction.colorize(with: UIColor.darkGray, colorBlendFactor: 1, duration: 0))
        }
    }
    
    // MARK: - Convenience Init
    convenience init() {
        self.init(imageNamed: "Heart")
        self.color = UIColor.infared
    }
}

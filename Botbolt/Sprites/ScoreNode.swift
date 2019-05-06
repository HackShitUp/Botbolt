//
//  ScoreNode.swift
//  Botbolt
//
//  Created by Joshua Choi on 4/30/2019.
//  Copyright © 2019 Nanogram LLC. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit


/**
 Abstract: Custom SKLabelNode used to display the user's current score
 */
class ScoreNode: SKLabelNode {

    // MARK: - Class Vars
    
    /// Initialized Int value used to set the score for the label
    var score: Int = 0 {
        didSet {
            self.text = "\(score)"
        }
    }
}

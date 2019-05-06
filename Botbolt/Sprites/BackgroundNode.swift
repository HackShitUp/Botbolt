//
//  BackgroundNode.swift
//  Botbolt
//
//  Created by Joshua Choi on 4/30/2019.
//  Copyright © 2019 Nanogram LLC. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit


/**
 Abstract: Custom SKEmitterNode acting as the background design of the game's main interface.
 */
class BackgroundNode: SKEmitterNode {
    
    /// MARK: - Convenience Init
    convenience override init() {
        self.init(fileNamed: "Magic")!
        advanceSimulationTime(10)
    }
}

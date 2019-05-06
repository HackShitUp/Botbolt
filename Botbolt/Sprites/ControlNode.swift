//
//  ControlNode.swift
//  Botbolt
//
//  Created by Joshua Choi on 4/30/2019.
//  Copyright © 2019 Nanogram LLC. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

/**
 MARK: - ControlNodeDirection
 Enum used to delegae controls between left and right for moving the player object as well as other actions.
 */
enum ControlNodeDirection: String {
    case left = "LeftButton"
    case right = "RightButton"
    case fire = "AButton"
}

/**
 MARK: - ControlNodeDelegate
 */
protocol ControlNodeDelegate: class {
    /// Called when the user tapped the ControlNode.
    /// - Parameter control: A ControlNode object.
    func tappedControl(_ control: ControlNode)
}

/**
 Abstract: A SKSpriteNode object used to manage controls for the game.
 */
class ControlNode: SKSpriteNode {
    
    // MARK: - ControlNodeDirection
    var type: ControlNodeDirection!
    
    // MARK: - ControlNodeDelegate
    var delegate: ControlNodeDelegate!

    /// Initialized String value representing the image name of this control node
    var imageName: String = "LeftButton"

    /// MARK: - Init
    /// - Parameter t: A ControlNodeDirectionType enum representing whether this control will allows the object to move left or right.
    /// - Parameter d: A ControlNodeDelegate.
    convenience init(_ t: ControlNodeDirection, _ d: ControlNodeDelegate!) {
        self.init(imageNamed: t.rawValue)
        
        // Allow user interactions
        isUserInteractionEnabled = true

        // MARK: - ControlNodeDirection
        self.type = t
        
        // MARK: - ControlNodeDelegate
        self.delegate = d
    }
    
    // MARK: - UITouch
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        isUserInteractionEnabled = true
        
        // MARK: - ControlNodeDelegate
        delegate!.tappedControl(self)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        isUserInteractionEnabled = true
        
        // MARK: - ControlNodeDelegate
        delegate!.tappedControl(self)
    }
}

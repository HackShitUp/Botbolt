//
//  GameViewController.swift
//  Saberbolt
//
//  Created by Joshua Choi on 4/30/2019.
//  Copyright © 2019 Nanogram LLC. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit


/**
 Abstract: View controller class that provides the main
 */
class GameViewController: UIViewController {
    
    // MARK: - Class Vars
    
    // MARK: - GameScene
    var gameScene: GameScene!
    
    // MARK: - IBOutlets
    @IBOutlet weak var skView: SKView!
    
    /// MARK: - Init
    init() {
        super.init(nibName: "GameViewController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: - View Controller Life Cycle
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // Hide the status
        hideStatusBar()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup the background color
        view.backgroundColor = .black
        
        // MARK: - GameScene
        gameScene = GameScene(size: skView.frame.size)
        gameScene.gameViewController = self
        
        // MARK: - SKView
        skView.showsFPS = true
        skView.showsNodeCount = true
        skView.ignoresSiblingOrder = true
        skView.presentScene(gameScene)
    }
    
    /// Restart the game
    open func restartGame() {
        // MARK: - GameScene
        // De-allocate and reinitialize
        gameScene.removeFromParent()
        gameScene = nil
        gameScene = GameScene(size: skView.frame.size)
        gameScene.gameViewController = self
        
        // MARK: - SKView
        // Re-present the game scene
        skView.presentScene(gameScene)
    }
}

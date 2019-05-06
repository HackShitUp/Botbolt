//
//  InitialViewController.swift
//  Saberbolt
//
//  Created by Joshua Choi on 5/5/19.
//  Copyright © 2019 Nanogram LLC. All rights reserved.
//

import UIKit
import CoreData
import SpriteKit

/**
 Abstract: Initial view controller class to display options
 */
class InitialViewController: UIViewController {

    // MARK: - IBActions
    @IBOutlet weak var playButton: UIButton!
    @IBAction func playButton(_ sender: Any) {
        // MARK: - GameViewController
        let gameVC = GameViewController()
        self.present(gameVC, animated: false, completion: nil)
    }
    
    // MARK: - View Controller Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // playButton
        playButton.setButtonTitle(titleAttributes: NSAttributedString(string: "PLAY", attributes: [.foregroundColor: UIColor.white, .font: UIFont.heavy(size: 21)]), borderColor: .clear, backgroundColor: UIColor.babyBlue, borderWidth: 0, cornerRadii: 20)
        playButton.layer.applyShadow()
    }
}

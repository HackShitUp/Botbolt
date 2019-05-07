//
//  InitialViewController.swift
//  Saberbolt
//
//  Created by Joshua Choi on 4/30/2019.
//  Copyright © 2019 Nanogram LLC. All rights reserved.
//

import UIKit
import CoreData
import SpriteKit

/**
 Abstract: Initial view controller class to display options
 */
class InitialViewController: UIViewController {
    
    // MARK: - Class Vars
    var label: UILabel!

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
        
        // Set the backgrond color
        view.backgroundColor = .black
        
        // label
        label = UILabel(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 100))
        label.center = view.center
        label.center.y = 100
        label.textAlignment = .center
        label.font = UIFont.heavy(size: 40)
        label.textColor = .white
        label.text = "B O L T B O T"
        label.layer.applyShadow()
        view.addSubview(label)
        
        // playButton
        playButton.setButtonTitle(titleAttributes: NSAttributedString(string: "PLAY", attributes: [.foregroundColor: UIColor.white, .font: UIFont.heavy(size: 21)]), borderColor: .clear, backgroundColor: UIColor.infared, borderWidth: 0, cornerRadii: 20)
        playButton.layer.applyShadow()
    }
}

//
//  GameOverViewController.swift
//  knotz
//
//  Created by Preston Price on 1/14/16.
//  Copyright © 2016 prestonwprice. All rights reserved.
//

import UIKit

class GameOverViewController: UIViewController {
    
    @IBOutlet weak var restartButton: UIButton!
    @IBOutlet weak var mainMenu: UIButton!
    @IBOutlet weak var skipButton: UIButton!
    
    
    @IBAction func skipPressed(_ sender: AnyObject) {
        let gameView = self.presentingViewController as! GameViewController
        let gameScene = gameView.skView.scene as! GameScene

        gameScene.restartLevel(gameScene.level+1)
        
    }

    
    @IBAction func restartClicked(_ sender: AnyObject) {
        let gameView = self.presentingViewController as! GameViewController
        let gameScene = gameView.skView.scene as! GameScene
        gameScene.restartLevel(gameScene.level)
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}

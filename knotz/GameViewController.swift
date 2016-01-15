//
//  GameViewController.swift
//  BrickBreak
//
//  Created by Preston Price on 12/17/15.
//  Copyright (c) 2015 prestonwprice. All rights reserved.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController {
    
    var level = 0
    
    @IBOutlet weak var movesLeft: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let scene = GameScene(fileNamed:"GameScene") {
            // Configure the view.
            let skView = self.view as! SKView
            
            /* Sprite Kit applies additional optimizations to improve rendering performance */
            skView.ignoresSiblingOrder = true
            
            /* Set the scale mode to scale to fit the window */
            scene.scaleMode = .AspectFill
            scene.size = skView.bounds.size
            scene.viewController = self
            scene.level = self.level
            scene.backgroundColor = UIColor(red: 235/256, green: 235/256, blue: 235/256, alpha: 1.0)
            scene.screenHeight = self.view.bounds.maxY
            scene.screenWidth = self.view.bounds.maxX
            
            skView.presentScene(scene)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "gameEnded" {
            if let destination = segue.destinationViewController as? EndGameViewController {
                destination.level = self.level
                
                if let send = sender as? GameScene {
                    destination.stars = send.determineStars()
                }
            }
        }
    }
    
    override func shouldAutorotate() -> Bool {
        return true
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return .AllButUpsideDown
        } else {
            return .All
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}

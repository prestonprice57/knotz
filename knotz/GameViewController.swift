//
//  GameViewController.swift
//  BrickBreak
//
//  Created by Preston Price on 12/17/15.
//  Copyright (c) 2015 prestonwprice. All rights reserved.
//

import UIKit
import SpriteKit
import GoogleMobileAds

class GameViewController: UIViewController {
    
    @IBOutlet weak var bannerView: GADBannerView!
    
    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var label2: UILabel!
    
    var level = 0
    var skView: SKView!
    
    @IBOutlet weak var movesLeft: UILabel!
    
    @IBAction func babkButtonPressed(_ sender: AnyObject) {
        self.performSegue(withIdentifier: "toLevelVC", sender: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.bannerView.adUnitID = "ca-app-pub-2794069200159212/1016212489"
        self.bannerView.rootViewController = self
        self.bannerView.load(GADRequest())
        
        if let scene = GameScene(fileNamed:"GameScene") {
            // Configure the view.
            skView = self.view as! SKView
            
            /* Sprite Kit applies additional optimizations to improve rendering performance */
            skView.ignoresSiblingOrder = true
            
            /* Set the scale mode to scale to fit the window */
            scene.scaleMode = .aspectFill
            scene.size = skView.bounds.size
            scene.viewController = self
            scene.level = self.level
            scene.backgroundColor = UIColor(red: 235/256, green: 235/256, blue: 235/256, alpha: 1.0)
            scene.screenHeight = self.view.bounds.maxY
            scene.screenWidth = self.view.bounds.maxX
            
            skView.presentScene(scene)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "toLevelVC" {
            for subview in self.view.subviews {
                print(subview)
                subview.removeFromSuperview()
            }
            skView.scene?.removeAllActions()
            skView.scene?.removeAllChildren()
            skView.presentScene(nil)
            self.bannerView = nil
            
        }
    }
    
    override func shouldAutorotate() -> Bool {
        return true
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        if UIDevice.current().userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
    }
    
    
}

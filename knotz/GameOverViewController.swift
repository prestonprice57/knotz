//
//  GameOverViewController.swift
//  knotz
//
//  Created by Preston Price on 1/14/16.
//  Copyright © 2016 prestonwprice. All rights reserved.
//

import UIKit
import GoogleMobileAds

class GameOverViewController: UIViewController {
    
    @IBOutlet weak var bannerView: GADBannerView!
    @IBOutlet weak var restartButton: UIButton!
    @IBOutlet weak var mainMenu: UIButton!
    @IBOutlet weak var skipButton: UIButton!
    
    
    @IBAction func skipPressed(_ sender: AnyObject) {
        let gameView = self.presentingViewController as! GameViewController
        let gameScene = gameView.skView.scene as! GameScene
        
        let ac = UIAlertController(title: "Would you like to watch an ad to skip this level?", message: nil, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        ac.addAction(UIAlertAction(title: "Yes", style: .default) { [unowned self] _ in
            self.dismiss(animated: true) {
                AdColony.playVideoAd(forZone: "vz9eecf4a90d0745098f", with: nil)
            }
        })
        
        
        present(ac, animated: true, completion: nil)

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
        
        self.bannerView.adUnitID = "ca-app-pub-2794069200159212/8399878480"
        self.bannerView.rootViewController = self
        self.bannerView.load(GADRequest())
    }
}

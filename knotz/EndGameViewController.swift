//
//  EndGameViewController.swift
//  knotz
//
//  Created by Preston Price on 1/13/16.
//  Copyright © 2016 prestonwprice. All rights reserved.
//

import Foundation
import UIKit
import GoogleMobileAds

class EndGameViewController: UIViewController {
    
    @IBOutlet weak var star3: UIImageView!
    @IBOutlet weak var star2: UIImageView!
    @IBOutlet weak var star1: UIImageView!
    @IBOutlet weak var bannerView: GADBannerView!
    
    @IBOutlet weak var nextLevel: UIButton!
    @IBOutlet weak var menuButton: UIButton!
    
    @IBOutlet weak var completedText: UILabel!
    @IBOutlet weak var levelText: UILabel!
    
    var level: Int!
    var stars: Int!
    
    
    override func viewDidLoad() {
        level = 0
        
        self.bannerView.adUnitID = "ca-app-pub-2794069200159212/9876611683"
        self.bannerView.rootViewController = self
        self.bannerView.load(GADRequest())
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let gameView = self.presentingViewController as! GameViewController
        let gameScene = gameView.skView.scene as! GameScene
        
        level = gameScene.level

        if level > 24 {
            nextLevel.isHidden = true
            //menuButton.hidden = true
            
            star1.isHidden = true
            star2.isHidden = true
            star3.isHidden = true
            
            levelText.text = "Congratulations!"
            completedText.text = "You beat all the levels!"
            completedText.font = UIFont(name: (completedText.font?.fontName)!, size: 20)
        }
        
        let user = User(maxLevel: level)
        displayStars(user)
        
        let oldMaxLevel = user.loadSaved()
        if oldMaxLevel < level {
            user.maxLevel = level
            user.save()
        }
        
        
    }
    
    
    @IBAction func nextTapped(_ sender: AnyObject) {
        let gameView = self.presentingViewController as! GameViewController
        let gameScene = gameView.skView.scene as! GameScene
        
        gameScene.level += 1
        gameScene.restartLevel(gameScene.level)
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func displayStars(_ user: User) {
        var starsPerLevel = user.loadSavedStarArray()
        
        if stars == 1 {
            if starsPerLevel[level-2] < 1 {
              starsPerLevel[level-2] = 1
            }
            star1.image = UIImage(named: "star.png")
            star2.image = UIImage(named: "blankStar.png")
            star3.image = UIImage(named: "blankStar.png")
        } else if stars == 2 {
            if starsPerLevel[level-2] < 2 {
                starsPerLevel[level-2] = 2
            }
            star1.image = UIImage(named: "star.png")
            star2.image = UIImage(named: "star.png")
            star3.image = UIImage(named: "blankStar.png")
        } else if stars == 3 {
            if starsPerLevel[level-2] < 3 {
                starsPerLevel[level-2] = 3
            }
            star1.image = UIImage(named: "star.png")
            star2.image = UIImage(named: "star.png")
            star3.image = UIImage(named: "star.png")
        } else if stars == 0 {
            starsPerLevel[level-2] = 0
            star1.image = UIImage(named: "blankStar.png")
            star2.image = UIImage(named: "blankStar.png")
            star3.image = UIImage(named: "blankStar.png")
        }
        
        user.starsPerLevel = starsPerLevel
        
        user.saveStarArray()
    }
    
    
    
}

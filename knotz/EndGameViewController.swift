//
//  EndGameViewController.swift
//  knotz
//
//  Created by Preston Price on 1/13/16.
//  Copyright © 2016 prestonwprice. All rights reserved.
//

import Foundation
import UIKit

class EndGameViewController: UIViewController {
    
    @IBOutlet weak var star3: UIImageView!
    @IBOutlet weak var star2: UIImageView!
    @IBOutlet weak var star1: UIImageView!
    
    @IBOutlet weak var nextLevel: UIButton!
    
    var level: Int!
    var stars: Int!
    
    
    override func viewDidLoad() {
        displayStars()

        nextLevel.layer.borderColor = UIColor.blackColor().CGColor
        nextLevel.layer.borderWidth = 1.0
        level!++
        
        let user = User(maxLevel: level!)
        let oldMaxLevel = user.loadSaved()
        if oldMaxLevel < level {
            user.save()
        }
        
        
        
    }
    
    func displayStars() {
        if stars == 1 {
            star1.image = UIImage(named: "goldStar.png")
            star2.image = UIImage(named: "blankStar.png")
            star3.image = UIImage(named: "blankStar.png")
        } else if stars == 2 {
            star1.image = UIImage(named: "goldStar.png")
            star2.image = UIImage(named: "goldStar.png")
            star3.image = UIImage(named: "blankStar.png")
        } else if stars == 3 {
            star1.image = UIImage(named: "goldStar.png")
            star2.image = UIImage(named: "goldStar.png")
            star3.image = UIImage(named: "goldStar.png")
        } else {
            star1.image = UIImage(named: "blankStar.png")
            star2.image = UIImage(named: "blankStar.png")
            star3.image = UIImage(named: "blankStar.png")
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "nextLevel" {
            if let destination = segue.destinationViewController as? GameViewController {
                destination.level = self.level!
            }
        }
    }
    
}

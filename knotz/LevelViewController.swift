//
//  LevelViewController.swift
//  BrickBreak
//
//  Created by Preston Price on 1/8/16.
//  Copyright © 2016 prestonwprice. All rights reserved.
//

import Foundation
import UIKit
import GoogleMobileAds

class LevelViewController: UIViewController {
    
    @IBOutlet var buttons: [UIButton]!
    var maxLevelCompleted: Int!
    
    override func viewWillAppear(animated: Bool) {
        
        
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // disable or enable buttons
        for (i, button) in buttons.enumerate() {
            if i < maxLevelCompleted {
                button.enabled = true
            } else {
                button.enabled = false
            }
        }
        
        let user = User(maxLevel: maxLevelCompleted)
        let starsPerLevel = user.loadSavedStarArray()
        
        for (i, stars) in starsPerLevel.enumerate() {
            if stars == 1 {
                buttons[i].setBackgroundImage(UIImage(named: "1star.png"), forState: UIControlState.Normal)
            } else if stars == 2 {
                buttons[i].setBackgroundImage(UIImage(named: "2star.png"), forState: UIControlState.Normal)
            } else if stars == 3 {
                buttons[i].setBackgroundImage(UIImage(named: "3star.png"), forState: UIControlState.Normal)
            } else {
                buttons[i].setBackgroundImage(UIImage(named: "0star.png"), forState: UIControlState.Normal)
            }
        }

    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "levelNumber" {
            if let destination = segue.destinationViewController as? GameViewController {
                if let button = sender as! UIButton? {
                    destination.level = Int(button.currentTitle!)!
                }
            }
        }
    }
    
    @IBAction func returnToLevelView(segue: UIStoryboardSegue) {
        let user = User(maxLevel: 1)
        maxLevelCompleted = user.loadSaved()
    }
    /*override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        print("this worked")
        return false
    }*/
}

//
//  LevelViewController.swift
//  BrickBreak
//
//  Created by Preston Price on 1/8/16.
//  Copyright © 2016 prestonwprice. All rights reserved.
//

import Foundation
import UIKit

class LevelViewController: UIViewController {
    
    @IBOutlet var buttons: [UIButton]!
    var maxLevelCompleted: Int!
    
    override func viewWillAppear(animated: Bool) {
        print(buttons.count)
        
        for (i, button) in buttons.enumerate() {
            if i < maxLevelCompleted {
                button.enabled = true
            } else {
                button.enabled = false
                button.backgroundColor = UIColor.grayColor()
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
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
    
    /*override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        print("this worked")
        return false
    }*/
}

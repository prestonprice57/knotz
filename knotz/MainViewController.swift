//
//  MainViewController.swift
//  BrickBreak
//
//  Created by Preston Price on 1/8/16.
//  Copyright © 2016 prestonwprice. All rights reserved.
//

import Foundation
import UIKit

class MainViewController: UIViewController {
    
    var user: User!
    var maxLevel: Int!
    
    @IBOutlet weak var playButton: UIButton!
    
    @IBAction func playPressed(sender: AnyObject) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        user = User(maxLevel: 1)
        maxLevel = user.loadSaved()
                
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "play" {
            if let destination = segue.destinationViewController as? LevelViewController {
                //print(destination.buttons)
                destination.maxLevelCompleted = maxLevel!
            }
        }
    }
    
}
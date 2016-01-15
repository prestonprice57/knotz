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
    
    @IBAction func restartClicked(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: {})
        
    }
    
    @IBAction func menuClicked(sender: AnyObject) {
        
    }
    
    override func viewDidLoad() {
        restartButton.layer.borderWidth = 1.0
        mainMenu.layer.borderWidth = 1.0
        
        restartButton.layer.borderColor = UIColor.blackColor().CGColor
        mainMenu.layer.borderColor = UIColor.blackColor().CGColor
    }
}
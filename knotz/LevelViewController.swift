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
    
    var buttons: [UIButton]! = []
    var maxLevelCompleted: Int!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewWillAppear(_ animated: Bool) {
        
        
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let width = UIScreen.main().bounds.width
        let height = UIScreen.main().bounds.height
        
        //determine button size 5x8=40
        // 5 is number of spaces in row
        // 8 is number of pixels of separation
        let buttonWidth = (width-40.0)/4.0
        let buttonHeight = buttonWidth
        
        print(buttonWidth)
        
        let startX: CGFloat = 8.0
        let startY: CGFloat = 70.0 //pixels
        let spacing: CGFloat = 8.0 //pixels
        
        
        for i in 1...24 {
            let x = (CGFloat((i-1)%4)*(buttonWidth+spacing))+startX
            let y = (CGFloat(Int((i-1)/4))*(buttonHeight+spacing))+startY
            
            let button = UIButton()
            button.frame = CGRect(x: x, y: y, width: buttonWidth, height: buttonHeight)
            button.setTitle(String(i), for: UIControlState())
            button.titleEdgeInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: buttonWidth/2.8, right: 0.0)
            button.titleLabel?.font = UIFont(name: "Gill Sans", size: 30)
            
            
            button.setBackgroundImage(UIImage(named: "0star_disabled.png"), for: UIControlState.disabled)
            button.addTarget(self, action: #selector(LevelViewController.segueToGameVC(button:)), for: UIControlEvents.touchUpInside)
            
            buttons.append(button)
            self.view.addSubview(button)
        }
        
        
        // disable or enable buttons
        for (i, button) in buttons.enumerated() {
            if i < maxLevelCompleted {
                button.isEnabled = true
            } else {
                button.isEnabled = false
            }
        }
        
        let user = User(maxLevel: maxLevelCompleted)
        let starsPerLevel = user.loadSavedStarArray()
        
        for (i, stars) in starsPerLevel.enumerated() {
            if stars == 1 {
                buttons[i].setBackgroundImage(UIImage(named: "1star.png"), for: UIControlState())
            } else if stars == 2 {
                buttons[i].setBackgroundImage(UIImage(named: "2star.png"), for: UIControlState())
            } else if stars == 3 {
                buttons[i].setBackgroundImage(UIImage(named: "3star.png"), for: UIControlState())
            } else {
                buttons[i].setBackgroundImage(UIImage(named: "0star.png"), for: UIControlState())
            }
        }
        
        //scrollView.contentSize = CGSize(width: self.view.frame.width, height: self.view.frame.height+500.0)

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "toGameVC" {
            if let destination = segue.destinationViewController as? GameViewController {
                if let button = sender as! UIButton? {
                    destination.level = Int(button.currentTitle!)!
                }
            }
        }
    }
    
    func segueToGameVC(button: UIButton) {
        self.animate(button: button, segueName: "toGameVC")
    }
    
    @IBAction func returnToLevelVC(segue: UIStoryboardSegue) {
        return
    }
    
    func animate(button: UIButton, segueName: String) {
        UIView.animate(withDuration: 0.15,
                       animations: { () -> Void in
                        button.transform = CGAffineTransform(scaleX: 0.85, y: 0.85)
                        self.performSegue(withIdentifier: segueName, sender: button)
            }, completion: { (Bool) in
                UIView.animate(withDuration: 0.1,
                               animations: { () -> Void in
                                button.transform = CGAffineTransform.identity
                    }, completion: nil)
        })
    }
    
    @IBAction func returnToLevelView(_ segue: UIStoryboardSegue) {
        let user = User(maxLevel: 1)
        maxLevelCompleted = user.loadSaved()
    }
    /*override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        print("this worked")
        return false
    }*/
}

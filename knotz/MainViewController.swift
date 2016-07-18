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
    
    @IBAction func playPressed(_ sender: UIButton) {
        if let button = sender as UIButton! {
            self.animate(button: button, segueName: "toLevelVC")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        user = User(maxLevel: 1)
        maxLevel = user.loadSaved()
        
        
                
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: AnyObject?) {

        
        if segue.identifier == "toLevelVC" {
            if let destination = segue.destinationViewController as? LevelViewController {
                destination.maxLevelCompleted = maxLevel!
            }
        }
    }
    
    @IBAction func segueToLevelVB(segue: UIStoryboardSegue) {
        
    }
    
    @IBAction func returnToMainMenu(_ segue: UIStoryboardSegue) {
        maxLevel = user.loadSaved()
    }
    
    func animate(button: UIButton, segueName: String) {
        UIView.animate(withDuration: 0.15,
            animations: { () -> Void in
            button.transform = CGAffineTransform(scaleX: 0.85, y: 0.85)
            }, completion: { (Bool) in
                UIView.animate(withDuration: 0.1,
                    animations: { () -> Void in
                    button.transform = CGAffineTransform.identity
                    self.performSegue(withIdentifier: segueName, sender: nil)
                }, completion: nil)
        })
    }
    
}

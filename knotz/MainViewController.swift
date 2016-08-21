//
//  MainViewController.swift
//  BrickBreak
//
//  Created by Preston Price on 1/8/16.
//  Copyright © 2016 prestonwprice. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    let sharedData = Data.sharedData
    
    @IBOutlet weak var activityView: UIActivityIndicatorView!
    @IBOutlet weak var playButton: UIButton!
    
    @IBAction func playPressed(_ sender: UIButton) {
        if let button = sender as UIButton! {
            self.animate(button: button, segueName: "toCategoryVC")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Create data file path if it does not exist
        let fileManager = FileManager()
        if !fileManager.fileExists(atPath: DataFilePath.categoryData) {
            let created = fileManager.createFile(atPath: DataFilePath.categoryData, contents: nil, attributes: nil)
            if created {
                print("File created ")
            } else {
                print("Couldn't create file for some reason")
            }
            activityView.startAnimating()
            let sharedData = Data.sharedData
            sharedData.loadData() { [unowned self] (Void) in
                self.activityView.stopAnimating()
                self.activityView.hidesWhenStopped = true
                
                let data = NSKeyedArchiver.archivedData(withRootObject: sharedData.mainData)
                
                do {
                    let url = URL(fileURLWithPath: DataFilePath.categoryData)
                    try data.write(to: url, options: .atomic)
                } catch {
                    print("Error writing to file")
                }
                

                
                
                let fileContents = fileManager.contents(atPath: DataFilePath.categoryData)
                let json = NSKeyedUnarchiver.unarchiveObject(with: fileContents!)
                print(json)
            }
        } else {
            let fileContents = fileManager.contents(atPath: DataFilePath.categoryData)
            if let json = NSKeyedUnarchiver.unarchiveObject(with: fileContents!) as? NSDictionary {
                sharedData.mainData = json
            }
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: AnyObject?) {

        
        if segue.identifier == "toCategoryVC" {

        }
    }
    
    @IBAction func returnToMainMenu(_ segue: UIStoryboardSegue) {
        
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
    
    override var prefersStatusBarHidden: Bool {
        get {
            return true
        }
    }
}

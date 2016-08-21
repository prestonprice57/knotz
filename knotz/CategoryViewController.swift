//
//  CategoryViewController.swift
//  knotz
//
//  Created by Price,Preston on 7/19/16.
//  Copyright © 2016 prestonwprice. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class CategoryViewController: UITableViewController {
    
    var categories: [String] = []
    let sharedData = Data.sharedData
    
    required init(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)!
    }
    
    override func viewDidLoad() {
        self.tableView.contentInset = UIEdgeInsets(top: -28.0, left: 0.0, bottom: 0.0, right: 0.0)
    }
    override func viewWillAppear(_ animated: Bool) {
        
        for category in (sharedData.mainData["categories"] as? NSArray)! {
            if let categoryName = category["categoryName"] as! String! {
                categories.append(categoryName)
            }
        }
        
        let backButton = UIButton(type: UIButtonType.custom)
        let backButtonImage = UIImage(named: "backButton")
        backButton.setImage(backButtonImage, for: UIControlState.normal)
        backButton.frame = CGRect(x: 0.0, y: 0.0, width: (backButtonImage?.size.width)!, height: (backButtonImage?.size.height)!)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(CategoryViewController.popView))
        backButton.addGestureRecognizer(tapGesture)
        
        let backButtonView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 30.0, height: 30.0))
        backButtonView.bounds = backButtonView.bounds.offsetBy(dx: 0.0, dy: 20.0)
        backButtonView.addSubview(backButton)
        
        
        let navItem = UIBarButtonItem(customView: backButtonView)
        navItem.tintColor = UIColor.white
        
        self.navigationItem.leftBarButtonItem = navItem
        
        let titleView = UIImageView(image: UIImage(named: "navTitleImage"))
        //titleView.bounds = titleView.bounds.offsetBy(dx: 0.0, dy: 20.0)
        let titleViewContainer = UIView(frame: CGRect(x: 0.0, y: 0.0, width: titleView.frame.size.width, height: titleView.frame.size.height))
        titleViewContainer.bounds = titleViewContainer.bounds.offsetBy(dx: 0.0, dy: 15.0)
        titleViewContainer.addSubview(titleView)
        self.navigationItem.titleView = titleViewContainer
    }
    
    override func viewDidLayoutSubviews() {
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath) as! CategoryTableViewCell
        

        let image = UIImage(named: "category\(self.categories[indexPath.row])")
        cell.categoryImageView.image = image
        cell.categoryImageView.contentMode = UIViewContentMode.scaleAspectFit
        cell.categoryName.text = self.categories[indexPath.row]
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(CategoryViewController.toLevelVC))
        cell.addGestureRecognizer(tapGesture)
        
        return cell
    }
    
    func toLevelVC() {
        performSegue(withIdentifier: "toLevelVC", sender: self)
    }
    
    func popView() {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    override var prefersStatusBarHidden: Bool {
        get {
            return true
        }
    }
    
    
}

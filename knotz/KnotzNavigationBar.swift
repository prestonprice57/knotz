//
//  KnotzNavigationBar.swift
//  knotz
//
//  Created by Price,Preston on 7/18/16.
//  Copyright © 2016 prestonwprice. All rights reserved.
//

import UIKit

class KnotzNavigationBar: UINavigationBar {
    
//    let navItem = UINavigationItem(title: "")
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.frame.size.height = 100.0
        self.barTintColor = UIColor(red: 155.0/255.0, green: 155.0/255.0, blue: 155.0/255.0, alpha: 1.0)
        
        
        
    }
    
    
    
    
}

//
//  Data.swift
//  knotz
//
//  Created by Price,Preston on 7/21/16.
//  Copyright © 2016 prestonwprice. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

func getDocumentsDirectory() -> String {
    let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
    let documentsDirectory = paths[0]
    return documentsDirectory
}


struct DataFilePath {
    static let categoryData = getDocumentsDirectory() + "/categoryData.json"
    static let userData = getDocumentsDirectory() + "/userData.json"
}

class Data {
    static let sharedData = Data()
    
    var mainData: NSDictionary!
    
    func loadData(completionBlock: (Void)->Void ) {
        let ref = FIRDatabase.database().reference()
        // move somewhere
        ref.observe(.value, with: { (snapshot) in
            if let categoriesJSON = snapshot.value as? NSDictionary {
                self.mainData = categoriesJSON
                print(categoriesJSON)
            }
            completionBlock()
        })
    }
}

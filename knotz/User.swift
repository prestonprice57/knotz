//
//  User.swift
//  knotz
//
//  Created by Preston Price on 1/13/16.
//  Copyright © 2016 prestonwprice. All rights reserved.
//

import Foundation

struct Properties {
    static var levelKey = "level"
}

class User: NSObject, NSCoding {
    
    var maxLevel: Int
    static let DocumentsDirectory = NSFileManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.URLByAppendingPathComponent("level")
    
    init(maxLevel: Int) {
        self.maxLevel = maxLevel
        
        super.init()
    }
    
    @objc func encodeWithCoder(aCoder: NSCoder) {
            aCoder.encodeInteger(maxLevel, forKey: Properties.levelKey)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let level = aDecoder.decodeObjectForKey(Properties.levelKey) as! Int
        
        self.init(maxLevel: level)
    }
    
    func save() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(maxLevel, toFile: User.ArchiveURL.path!)
        if !isSuccessfulSave {
            print("Failed to save meals...")
        }
    }
    
    func loadSaved() -> Int? {
        if let unload = NSKeyedUnarchiver.unarchiveObjectWithFile(User.ArchiveURL.path!) {
            return unload as? Int
        }
        return 1
    }
}
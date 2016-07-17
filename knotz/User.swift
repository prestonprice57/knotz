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
    static var starsKey = "stars"
}

class User: NSObject, NSCoding {
    
    var maxLevel: Int
    var starsPerLevel: [Int]
    
    static let DocumentsDirectory = FileManager().urlsForDirectory(.documentDirectory, inDomains: .userDomainMask).first!
    static let ArchiveURL = try! DocumentsDirectory.appendingPathComponent("level")
    
    static let ArchiveURL2 = try! DocumentsDirectory.appendingPathComponent("stars")
    
    init(maxLevel: Int) {
        self.maxLevel = maxLevel
        self.starsPerLevel = [Int](repeating: 0, count: 24)
        
        super.init()
    }
    
    @objc func encode(with aCoder: NSCoder) {
        aCoder.encode(maxLevel, forKey: Properties.levelKey)
        aCoder.encode(starsPerLevel, forKey: Properties.starsKey)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let level = aDecoder.decodeObject(forKey: Properties.levelKey) as! Int
        let stars = aDecoder.decodeObject(forKey: Properties.starsKey) as! [Int]
        
        self.init(maxLevel: level)
        starsPerLevel = stars
    }
    
    func save() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(maxLevel, toFile: User.ArchiveURL.path!)
        if !isSuccessfulSave {
            print("Failed to save maxLevel...")
        }
    }
    
    func saveStarArray() {
        let isSuccessfulSave2 = NSKeyedArchiver.archiveRootObject(starsPerLevel, toFile: User.ArchiveURL2.path!)
        if !isSuccessfulSave2 {
            print("Failed to save starsPerLevel...")
        }
    }
    
    func loadSaved() -> Int? {
        if let unload = NSKeyedUnarchiver.unarchiveObject(withFile: User.ArchiveURL.path!) {
            return unload as? Int
        }
        return 1
    }
    
    func loadSavedStarArray() -> [Int] {
        if let unload = NSKeyedUnarchiver.unarchiveObject(withFile: User.ArchiveURL2.path!) {
            return (unload as? [Int])!
        }
        return [Int](repeating: 0, count: 24)
    }
}

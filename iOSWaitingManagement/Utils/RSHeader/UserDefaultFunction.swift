//
//  UserDefaultFunction.swift
//  iOSWaitingManagement
//
//  Created by Akash on 12/27/18.
//  Copyright © 2018 Moin. All rights reserved.
//

import Foundation
import UIKit

class UserDefaultFunction: NSObject {
    
    //Set User default Dictionary
    class public func setCustomDictionary(dict: [String : AnyObject], key:String) {
        print(dict)
        let dictData = NSKeyedArchiver.archivedData(withRootObject: dict)
        UserDefaults.standard.set(dictData, forKey: key)
    }
    
    //BazarBit
//    class public func setCustomDictionary(dict: [String: Any], key:String) {
//        let dictData = NSKeyedArchiver.archivedData(withRootObject: dict)
//        UserDefaults.standard.set(dictData, forKey: key)
//    }
    
    //Get User default Dictionary
    class public func getDictionary(forKey: String) -> [String : AnyObject]? {
        let dictData = UserDefaults.standard.object(forKey: forKey)
        let object = NSKeyedUnarchiver.unarchiveObject(with: (dictData as! NSData) as Data)
        return object as? [String : AnyObject]
    }
    
    //BazarBit
//    class public func getDictionary(forKey: String) -> [String: Any]? {
//        let dictData = UserDefaults.standard.object(forKey: forKey)
//        let object = NSKeyedUnarchiver.unarchiveObject(with: (dictData as! NSData) as Data)
//        return object as? [String: Any]
//    }
}

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
    
    class public func setCustomDictionary(dict: [String : String], key:String) {
        print(dict)
        let dictData = NSKeyedArchiver.archivedData(withRootObject: dict)
        UserDefaults.standard.set(dictData, forKey: key)
    }
    
    class public func getDictionary(forKey: String) -> [String : String]? {
        let dictData = UserDefaults.standard.object(forKey: forKey)
        let object = NSKeyedUnarchiver.unarchiveObject(with: (dictData as! NSData) as Data)
        return object as? [String : String]
    }
}

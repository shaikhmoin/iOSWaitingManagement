//
//  RSTextView.swift
//  iOSWaitingManagement
//
//  Created by Akash on 12/27/18.
//  Copyright © 2018 Moin. All rights reserved.
//

import Foundation
import UIKit

class RSTextView: UITextView {
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        
        self.textColor = UIColor.lightGray
        self.layer.cornerRadius = 20.0
        self.tintColor = UIColor.black
        self.applyShadowDefault()
        self.backgroundColor = UIColor.white
    }
}

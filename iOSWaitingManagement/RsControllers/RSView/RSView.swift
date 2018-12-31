//
//  RSView.swift
//  iOSWaitingManagement
//
//  Created by Akash on 12/27/18.
//  Copyright © 2018 Moin. All rights reserved.
//

import Foundation
import UIKit

class RSBorderView: UIView {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.layer.borderWidth = 2.0
        self.layer.borderColor = UIColor.black.cgColor
        self.applyShadowDefault()
    }
}

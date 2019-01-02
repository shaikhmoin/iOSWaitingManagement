//
//  RSTableView.swift
//  iOSWaitingManagement
//
//  Created by Akash on 12/27/18.
//  Copyright © 2018 Moin. All rights reserved.


import Foundation
import UIKit

class RSTableView: UITableView {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.applyCornerRadius(10.0)
        
        if #available(iOS 11.0, *) {
            self.layer.maskedCorners = [.layerMaxXMaxYCorner,.layerMinXMaxYCorner ]
        } else {
            self.layer.ViewroundCorners(corners: [.bottomLeft, .bottomRight], radius: 10)
        }
    }
}

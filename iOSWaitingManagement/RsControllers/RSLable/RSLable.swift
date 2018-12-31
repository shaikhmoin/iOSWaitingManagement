//
//  RSLable.swift
//  iOSWaitingManagement
//
//  Created by Akash on 12/27/18.
//  Copyright © 2018 Moin. All rights reserved.
//

import Foundation
import UIKit

class RSTitleLable: UILabel {
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        
        self.backgroundColor = UIColor(hexString: CONSTANTS.APP_PRIMARY_LIGHT_COLOR)
        self.font = UIFont.appFont_LatoBold_WithSize(16.0)
        self.textColor = UIColor.white
        self.textAlignment = NSTextAlignment.center
    }
}

class RSCustomerTitleLable: UILabel {
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        
        self.font = UIFont.appFont_LatoRegular_WithSize(14)
        self.textColor = UIColor.black
        self.textAlignment = NSTextAlignment.center
    }
}

class RSTableTitleLable: UILabel {
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        
        self.font = UIFont.appFont_LatoRegular_WithSize(14)
        self.textColor = UIColor.white
        self.textAlignment = NSTextAlignment.center
    }
}



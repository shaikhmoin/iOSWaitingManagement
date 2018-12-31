//
//  RSButton.swift
//  iOSWaitingManagement
//
//  Created by Akash on 12/27/18.
//  Copyright © 2018 Moin. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

class RSButton: UIButton {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.backgroundColor = UIColor.white
        self.layer.cornerRadius = 10
        self.titleLabel?.font = UIFont.appFont_LatoBold_WithSize(60.0)
        self.titleLabel?.textColor = UIColor.black
        self.titleLabel?.textAlignment = NSTextAlignment.center
    }
}

class RSMainButton: UIButton {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.backgroundColor = UIColor(hexString: CONSTANTS.APP_PRIMARY_LIGHT_COLOR)
        self.titleLabel?.font = UIFont.appFont_LatoBold_WithSize(20.0)
        self.titleLabel?.textColor = UIColor.white
        self.titleLabel?.textAlignment = NSTextAlignment.center
    }
}

class RSHomeButton: UIButton {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.backgroundColor = UIColor(hexString: CONSTANTS.APP_MAIN_HOME_BUTTON_COLOR)
        self.titleLabel?.font = UIFont.appFont_LatoHeavy_WithSize(18)
        self.titleLabel?.textColor = UIColor.black
        self.titleLabel?.textAlignment = NSTextAlignment.center
    }
}






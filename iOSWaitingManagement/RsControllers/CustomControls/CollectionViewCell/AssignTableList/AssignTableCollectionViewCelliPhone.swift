//
//  AssignTableCollectionViewCelliPhone.swift
//  iOSWaitingManagement
//
//  Created by Akash on 1/2/19.
//  Copyright © 2019 Moin. All rights reserved.
//

import UIKit

class AssignTableCollectionViewCelliPhone: UICollectionViewCell {
    
    @IBOutlet weak var viewMain: UIView!
    @IBOutlet weak var imgTable: UIImageView!
    @IBOutlet weak var lblNumber: UILabel!
    @IBOutlet weak var lblItems: RSCustomerTitleLable!
    @IBOutlet weak var lblGuest: RSCustomerTitleLable!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    //MARK: SetUp Table Data
    func setUpTableData(modelData:[String:AnyObject]) {
        print(modelData)
        
        self.lblNumber.text = ResolutePOS.object_forKeyWithValidationForClass_String(dict: modelData, key: "TableNo")
        var strItems : String = ResolutePOS.object_forKeyWithValidationForClass_String(dict: modelData, key: "NoOfItem")
        if strItems == "" {
            strItems = "0"
        }
        
        var strGurest : String = ResolutePOS.object_forKeyWithValidationForClass_String(dict: modelData, key: "NoOfPax")
        if strGurest == "" {
            strGurest = "0"
        }
        self.lblGuest.text = "Guest" + ": " + strGurest
        self.lblItems.text = "Items" + ": " + strItems
        
        let strOrderID : String = ResolutePOS.object_forKeyWithValidationForClass_String(dict: modelData, key: "OrderID")
        print(strOrderID)
        
        if strOrderID == "0" || strOrderID == "" {
            imgTable.image = UIImage(named: "table_empty.png")
        } else {
            imgTable.image = UIImage(named: "table_selected.png")
        }
    }
}

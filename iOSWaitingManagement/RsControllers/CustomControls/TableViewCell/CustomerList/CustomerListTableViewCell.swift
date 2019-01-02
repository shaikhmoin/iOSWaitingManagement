//
//  CustomerListTableViewCell.swift
//  iOSWaitingManagement
//
//  Created by Akash on 12/31/18.
//  Copyright © 2018 Moin. All rights reserved.
//

import UIKit

class CustomerListTableViewCell: UITableViewCell {

    @IBOutlet weak var btnAssign: UIButton!
    @IBOutlet weak var btnDelete: UIButton!
    @IBOutlet weak var lblCustName: RSCustomerTitleLable!
    @IBOutlet weak var lblCustNumber: RSCustomerTitleLable!
    @IBOutlet weak var lblNoOfPax: RSCustomerTitleLable!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //MARK: SetUp Customer List Data
    func setUpCustomerListData(modelData:[String:AnyObject])  {
        let strCustName : String = ResolutePOS.object_forKeyWithValidationForClass_String(dict: modelData, key: "Name")
        let strCustNo = ResolutePOS.object_forKeyWithValidationForClass_String(dict: modelData, key: "ContactNo")
        let strNoOfPax = ResolutePOS.object_forKeyWithValidationForClass_String(dict: modelData, key: "NoOfPax")
        
        self.lblCustName.text = strCustName
        self.lblCustNumber.text = strCustNo
        self.lblNoOfPax.text = strNoOfPax
    }
}

//
//  CustomerListTableViewCell.swift
//  iOSWaitingManagement
//
//  Created by Akash on 12/29/18.
//  Copyright © 2018 Moin. All rights reserved.
//

import UIKit

class CustomerListTableViewCell: UITableViewCell {

    @IBOutlet weak var btnAssign: RSMainButton!
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
    func setUpCustomerData(modelData:[String:AnyObject])  {
        self.lblCustName.text = ResolutePOS.object_forKeyWithValidationForClass_String(dict: modelData, key: "Name")
        self.lblCustNumber.text = ResolutePOS.object_forKeyWithValidationForClass_String(dict: modelData, key: "ContactNo")
        self.lblNoOfPax.text = ResolutePOS.object_forKeyWithValidationForClass_String(dict: modelData, key: "NoOfPax")
    }
}

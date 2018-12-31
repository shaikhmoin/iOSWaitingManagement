//
//  CustomerSuggestionTableViewCell.swift
//  iOSWaitingManagement
//
//  Created by Akash on 12/31/18.
//  Copyright © 2018 Moin. All rights reserved.
//

import UIKit

class CustomerSuggestionTableViewCell: UITableViewCell {

    @IBOutlet weak var lblCustName: UILabel!
    
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
        let custName : String = ResolutePOS.object_forKeyWithValidationForClass_String(dict: modelData, key: "Name")
        let custNo = ResolutePOS.object_forKeyWithValidationForClass_String(dict: modelData, key: "ContactNo")
        
        
        self.lblCustName.text = custName + " " + "[" + custNo + "]"
    }
    
}

//
//  HomeViewController.swift
//  iOSWaitingManagement
//
//  Created by Akash on 12/28/18.
//  Copyright © 2018 Moin. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate {
    
    @IBOutlet var viewAddCustomer: RSBorderView!
    @IBOutlet weak var txtCustName: RSTextField!
    @IBOutlet weak var txtCustNo: RSTextField!
    @IBOutlet weak var txtNoOfPax: RSTextField!
    @IBOutlet weak var tblCustomerList: UITableView!
    
    var dimView:UIView?
    var aryDispCustomerList : [AnyObject] = [AnyObject]()
    var strTemp : String = ""
    var strCustomerAccountID : String = "0"
    
    //MARK:- UIView Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.isNavigationBarHidden = true
        tblCustomerList.dataSource = self
        tblCustomerList.delegate = self
        txtCustNo.delegate = self
        txtCustName.delegate = self
        txtNoOfPax.delegate = self
        
        tblCustomerList.rowHeight = UITableViewAutomaticDimension
        tblCustomerList.estimatedRowHeight = 120
        tblCustomerList.tableFooterView = UIView()
        
        self.addPropertyPopupFunctionForAddCustomer()
        self.setupCustData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    override var prefersStatusBarHidden: Bool {
//        return true
//    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    //UITextfield Delegate Methods
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        //Customer Number
        if textField == txtCustNo {
            if (textField.text?.characters.count)! == 1 && string == "" {
                return true
            }
            
            if string == ""
            {
                strTemp = (textField.text?.substring(to: (textField.text?.index(before: (textField.text?.endIndex)!))!))!
                
                if strTemp.characters.count == 10 {
                    self.helperForCustomerExist(custNumber: strTemp)
                    
                } else {
                    self.strCustomerAccountID = "0"
                    //self.txtCustName.text = ""
                }
            }
            else {
                strTemp = textField.text! + string
                
                if strTemp.characters.count == 10 {
                    self.helperForCustomerExist(custNumber: strTemp)
                    
                } else {
                    self.strCustomerAccountID = "0"
                    //self.txtCustName.text = ""
                }
            }
            return true
        }
        return true
    }
    
    //MARK:- UITableview Datasource Methods
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == tblCustomerList {
            return aryDispCustomerList.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == tblCustomerList {
            let customerListCell = tblCustomerList.dequeueReusableCell(withIdentifier: CONSTANTS.ID_CUSTOMR_LIST_TABLE_CELL, for: indexPath) as! CustomerListTableViewCell
            
            if aryDispCustomerList.count > 0 {
                customerListCell.setUpCustomerListData(modelData: aryDispCustomerList[indexPath.row] as! [String : AnyObject])
            }
            
            customerListCell.btnAssign.tag = indexPath.row
            customerListCell.btnAssign.addTarget(self, action: #selector(self.btnAssignTableClick), for: .touchUpInside)
            
            return customerListCell
        }
        return UITableViewCell()
    }
    
    //MARK:- UITableview Delegate Methods
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == tblCustomerList {
            return UITableViewAutomaticDimension
        }
        return 0
    }
    
    //MARK:- Button Click For Assign Table To Customer
    @objc func btnAssignTableClick(sender:UIButton) {
        let nav = self.storyboard?.instantiateViewController(withIdentifier: "AssignTableViewController") as! AssignTableViewController
        self.navigationController?.pushViewController(nav, animated: true)
    }
    
    //MARK:- Button Open Customer Popup Click
    @IBAction func btnOpenCustomerClick(_ sender: Any) {
        self.popUpShow(popupView: viewAddCustomer)
        txtCustNo.becomeFirstResponder()
    }
    
    //MARK:- Button Hide Popupick Click
    @IBAction func btnBackCustomerClick(_ sender: Any) {
        self.popUpHide(popupView: viewAddCustomer)
        self.helperForClearTextFieldData()
    }
    
    //MARK:- Button Save Customer Click
    @IBAction func btnSaveCustomerClick(_ sender: Any) {
        if txtCustNo.text == "" {
            RSAlertUtils.displayAlertWithMessage("Please Enter Customer Contact Number!")
        } else if txtCustNo.text!.count != 10 {
            RSAlertUtils.displayAlertWithMessage("Please Enter Valid Contact Number!")
        } else if txtCustName.text == "" {
            RSAlertUtils.displayAlertWithMessage("Please Enter Customer Name!")
        }   else if txtNoOfPax.text == "" {
            RSAlertUtils.displayAlertWithMessage("Please Enter No Of Pax!")
        } else {
            self.insertCustomerHelper()
        }
    }
    
    //MARK:- Button logout click
    @IBAction func btnLogoutClick(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK:- UIPopup helper methods
    func addPropertyPopupFunctionForAddCustomer()  {
        
        self.view.addSubview(viewAddCustomer)
        self.viewAddCustomer.alpha = 0.0
        
        var popupWidth: Int = 0
        var popupHeight: Int = 0
        
        if IS_IPAD_DEVICE() {
            popupWidth = 400
            popupHeight = 310
        } else {
            
            if ResolutePOS.DeviceType.IS_IPHONE_5_SE {
                popupWidth = 300
                popupHeight = 300
            } else {
                popupWidth = 350
                popupHeight = 300
            }
        }
        
        var x:Int = Int(UIScreen.main.bounds.width)
        var y:Int = Int(UIScreen.main.bounds.height)
        
        x =  (x - Int(popupWidth)) / 2
        y = (y - Int(popupHeight)) / 2
        
        viewAddCustomer.frame = CGRect(x: CGFloat(x), y: CGFloat(y), width: CGFloat(popupWidth), height: CGFloat(popupHeight))
        viewAddCustomer.layoutIfNeeded()
        self.view.addSubview(viewAddCustomer)
    }
    
    func popUpShow(popupView :UIView) {
        
        dimView = UIView()
        dimView?.frame = self.view.frame
        dimView?.backgroundColor = UIColor.lightGray
        dimView?.alpha = 0.5
        
        var x:Int = Int(UIScreen.main.bounds.width)
        var y:Int = Int(UIScreen.main.bounds.height)
        
        x =  (x - Int(popupView.frame.width)) / 2
        y = (y - Int(popupView.frame.height)) / 2
        
        popupView.frame = CGRect(x: CGFloat(x), y: CGFloat(y), width: popupView.frame.width, height: popupView.frame.height)
        popupView.layer.cornerRadius = 5.0
        popupView.layer.masksToBounds = true
        
        self.view.addSubview(dimView!)
        self.view.bringSubview(toFront: popupView)
        popupView.alpha = 1.0
    }
    
    func popUpHide(popupView :UIView) {
        dimView?.removeFromSuperview()
        popupView.alpha = 0.0
    }
    
    //MARK: Helper For Customer Exist Or Not
    func helperForCustomerExist(custNumber:String) {
        
        let query = String(format: "select * from CustomerMaster")
        let aryCustList = obj.getDynamicTableData(query: query)
        
        if aryCustList.count > 0 {
            var aryFinalCustList : [AnyObject] = [AnyObject]()
            for i in 0...aryCustList.count - 1 {
                
                let dict:[String: AnyObject] = aryCustList[i] as! [String: AnyObject]
                let mobileNo = ResolutePOS.object_forKeyWithValidationForClass_String(dict: dict, key: "ContactNo")
                
                //Match Mobile No And Get list of Customer
                if mobileNo == custNumber {
                    aryFinalCustList.append(dict as AnyObject)
                    
                    if aryFinalCustList.count > 0 {
                        let dict : [String:AnyObject] = aryFinalCustList[0] as! [String:AnyObject]
                        self.strCustomerAccountID = ResolutePOS.object_forKeyWithValidationForClass_String(dict: dict, key: "ID")
                        let strCustomerAccountName  = ResolutePOS.object_forKeyWithValidationForClass_String(dict: dict, key: "Name")
                        self.txtCustName.text = strCustomerAccountName
                        
                    } else {
                        self.strCustomerAccountID = "0"
                    }
                }
            }
        }
    }
    
    //MARK:- Helper for Insert Customer
    func insertCustomerHelper() {
        let query = "insert into CustomerMaster(Name,ContactNo,NoOfPax,IsAssign)values('\(txtCustName.text!)','\(txtCustNo.text!)','\(txtNoOfPax.text!)','\("")')"
        _ = obj.dboperation(query: query)
        self.popUpHide(popupView: viewAddCustomer)
        self.setupCustData()
        self.helperForClearTextFieldData()
    }
    
    //MARK:- Helper for Setup Customer Data
    func setupCustData() {
        
        let query = String(format: "select * from CustomerMaster")
        self.aryDispCustomerList = obj.getDynamicTableData(query: query)
        
        if self.aryDispCustomerList.count > 0 {
            tblCustomerList.reloadData()
        }
    }
    
    //MARK:- Helper For clear TextFields
    func helperForClearTextFieldData() {
        txtCustNo.text = ""
        txtNoOfPax.text = ""
        txtCustName.text = ""
        txtCustNo.resignFirstResponder()
        txtNoOfPax.resignFirstResponder()
        txtCustName.resignFirstResponder()
    }
}

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
    @IBOutlet var viewCustomerList: RSBorderView!
    @IBOutlet weak var viewCustomerSuggestionList: RSBorderView!
    @IBOutlet weak var txtCustName: RSTextField!
    @IBOutlet weak var txtCustNo: RSTextField!
    @IBOutlet weak var txtNoOfPax: RSTextField!
    @IBOutlet weak var tblCustomerList: UITableView!
    @IBOutlet weak var tblCustomerSuggestion: UITableView!
    
    var dimView:UIView?
    var aryDispCustomerList : [AnyObject] = [AnyObject]()
    var strTemp : String = ""
    var aryFilterCustomerList : [AnyObject] = [AnyObject]()
    var aryObjCustomerList : [AnyObject] = [AnyObject]()
    var strCustomerAccountID : String = "0"
    
    //MARK:- UIView Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.isNavigationBarHidden = true
        tblCustomerList.dataSource = self
        tblCustomerList.delegate = self
        tblCustomerSuggestion.dataSource = self
        tblCustomerSuggestion.delegate = self
        txtCustNo.delegate = self
        txtCustName.delegate = self
        txtNoOfPax.delegate = self
        
        self.tblCustomerList.register(UINib(nibName: "CustomerListTableViewCell", bundle: nil), forCellReuseIdentifier: CONSTANTS.ID_CUSTOMR_LIST_TABLE_CELL)
        self.tblCustomerSuggestion.register(UINib(nibName: "CustomerSuggestionTableViewCell", bundle: nil), forCellReuseIdentifier: CONSTANTS.ID_CUSTOMR_SUGGESTION_LIST_TABLE_CELL)
        
        tblCustomerList.rowHeight = UITableViewAutomaticDimension
        tblCustomerList.estimatedRowHeight = 100
        
        tblCustomerSuggestion.rowHeight = UITableViewAutomaticDimension
        tblCustomerSuggestion.estimatedRowHeight = 100
        
        tblCustomerList.tableFooterView = UIView()
        tblCustomerSuggestion.tableFooterView = UIView()
        
        self.addPropertyPopupFunctionForAddCustomer()
        self.addPropertyPopupFunctionForCustomerList()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
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
        
        //Customer Name
        if textField == txtCustName
        {
            if (textField.text?.characters.count)! == 1 && string == "" {
                aryFilterCustomerList = aryObjCustomerList
                if self.aryFilterCustomerList.count > 0 {
                    self.viewCustomerSuggestionList.isHidden = true
                } else {
                    self.viewCustomerSuggestionList.isHidden = false
                }
                self.tblCustomerSuggestion.reloadData()
                return true
            }
            
            if string == ""
            {
                strTemp = (textField.text?.substring(to: (textField.text?.index(before: (textField.text?.endIndex)!))!))!
            }
            else {
                strTemp = textField.text! + string
            }
            
            let preda = NSPredicate(format: "Name CONTAINS[c] '\(strTemp)'")
            aryFilterCustomerList = aryObjCustomerList.filter { preda.evaluate(with: $0) }
            if self.aryFilterCustomerList.count > 0 {
                viewCustomerSuggestionList.isHidden = false
                
            } else {
                viewCustomerSuggestionList.isHidden = true
            }
            self.tblCustomerSuggestion.reloadData()
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
        } else if tableView == tblCustomerSuggestion {
            return aryFilterCustomerList.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == tblCustomerList {
            let customerListCell = tblCustomerList.dequeueReusableCell(withIdentifier: CONSTANTS.ID_CUSTOMR_LIST_TABLE_CELL, for: indexPath) as! CustomerListTableViewCell
            
            if aryDispCustomerList.count > 0 {
                customerListCell.setUpCustomerData(modelData: aryDispCustomerList[indexPath.row] as! [String : AnyObject])
            }
            
            customerListCell.btnAssign.tag = indexPath.row
            customerListCell.btnAssign.addTarget(self, action: #selector(self.btnAssignTableClick), for: .touchUpInside)
            
            return customerListCell
            
        } else if tableView == tblCustomerSuggestion {
            let custSuggestionListCell = tblCustomerSuggestion.dequeueReusableCell(withIdentifier: CONSTANTS.ID_CUSTOMR_SUGGESTION_LIST_TABLE_CELL, for: indexPath) as! CustomerSuggestionTableViewCell
            
            if aryFilterCustomerList.count > 0 {
                custSuggestionListCell.setUpCustomerData(modelData: aryFilterCustomerList[indexPath.row] as! [String : AnyObject])
            }
            return custSuggestionListCell
        }
        return UITableViewCell()
    }
    
    //MARK:- UITableview Delegate Methods
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == tblCustomerSuggestion {
            
            if aryFilterCustomerList.count > 0 {
                let dictData : [String:AnyObject] = aryFilterCustomerList[indexPath.row] as! [String:AnyObject]
                print(dictData)
                
                let accountID = ResolutePOS.object_forKeyWithValidationForClass_String(dict: dictData, key: "ID")
                let custName = ResolutePOS.object_forKeyWithValidationForClass_String(dict: dictData, key: "Name")
                let custNo = ResolutePOS.object_forKeyWithValidationForClass_String(dict: dictData, key: "ContactNo")
                
                self.strCustomerAccountID = accountID
                self.txtCustNo.text = custNo
                self.txtCustName.text = custName
                
                self.txtCustNo.resignFirstResponder()
                self.txtCustName.resignFirstResponder()
                viewCustomerSuggestionList.isHidden = true
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == tblCustomerList {
            return UITableViewAutomaticDimension
        } else if tableView == tblCustomerSuggestion {
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
        self.helperForGetCustList()
    }
    
    //MARK:- Button Open Customer List Popup Cl;ick
    @IBAction func btnOpenCustListClick(_ sender: Any) {
        let query = String(format: "select * from CustomerMaster")
        self.aryDispCustomerList = obj.getDynamicTableData(query: query)
        
        if self.aryDispCustomerList.count > 0 {
            self.popUpShow(popupView: viewCustomerList)
            tblCustomerList.reloadData()
        } else {
            RSAlertUtils.displayAlertWithMessage("You have no any customer!")
        }
    }
    
    //MARK:- Button Hide Popupick Click
    @IBAction func btnBackCustomerClick(_ sender: Any) {
        self.popUpHide(popupView: viewAddCustomer)
        self.helperForClearTextFieldData()
    }
    
    //MARK:- Button Hide Cust List Popupick Click
    @IBAction func btnBackCustListClick(_ sender: Any) {
        self.popUpHide(popupView: viewCustomerList)
    }
    
    //MARK:- Button Hide Customer List Click
    @IBAction func btnBackCustomerListClick(_ sender: Any) {
        viewCustomerSuggestionList.isHidden = true
    }
    
    //MARK:- Button Save Customer Click
    @IBAction func btnSaveCustomerClick(_ sender: Any) {
        if txtCustName.text == "" {
            RSAlertUtils.displayAlertWithMessage("Please Enter Customer Name!")
        } else if txtCustNo.text == "" {
            RSAlertUtils.displayAlertWithMessage("Please Enter Customer Contact Number!")
        } else if txtCustNo.text!.count != 10 {
            RSAlertUtils.displayAlertWithMessage("Please Enter Valid Contact Number!")
        } else if txtNoOfPax.text == "" {
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
        
        popupWidth = 400
        popupHeight = 310
        
        var x:Int = Int(UIScreen.main.bounds.width)
        var y:Int = Int(UIScreen.main.bounds.height)
        
        x =  (x - Int(popupWidth)) / 2
        y = (y - Int(popupHeight)) / 2
        
        viewAddCustomer.frame = CGRect(x: CGFloat(x), y: CGFloat(y), width: self.view.frame.size.width, height: self.view.frame.size.height)
        viewAddCustomer.layoutIfNeeded()
        self.view.addSubview(viewAddCustomer)
    }
    
    func addPropertyPopupFunctionForCustomerList()  {
        
        self.view.addSubview(viewCustomerList)
        self.viewCustomerList.alpha = 0.0
        
        var popupWidth: Int = 0
        var popupHeight: Int = 0
        
        popupWidth = 400
        popupHeight = 310
        
        var x:Int = Int(UIScreen.main.bounds.width)
        var y:Int = Int(UIScreen.main.bounds.height)
        
        x =  (x - Int(popupWidth)) / 2
        y = (y - Int(popupHeight)) / 2
        
        viewCustomerList.frame = CGRect(x: CGFloat(x), y: CGFloat(y), width: self.view.frame.size.width, height: self.view.frame.size.height)
        viewCustomerList.layoutIfNeeded()
        self.view.addSubview(viewCustomerList)
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
    
    //MARK:- Helper For Getting All Customer List
    func helperForGetCustList() {
        let query = String(format: "select * from CustomerMaster")
        self.aryFilterCustomerList = obj.getDynamicTableData(query: query)
        self.aryObjCustomerList = obj.getDynamicTableData(query: query)
        viewCustomerSuggestionList.isHidden = true
    }
    
    //MARK:- Helper for Insert Customer
    func insertCustomerHelper() {
        let query = "insert into CustomerMaster(Name,ContactNo,NoOfPax,IsAssign)values('\(txtCustName.text!)','\(txtCustNo.text!)','\(txtNoOfPax.text!)','\("")')"
        _ = obj.dboperation(query: query)
        self.popUpHide(popupView: viewAddCustomer)
        self.helperForClearTextFieldData()
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

//
//  HomeViewController.swift
//  iOSWaitingManagement
//
//  Created by Akash on 12/28/18.
//  Copyright © 2018 Moin. All rights reserved.

import UIKit
import Alamofire

class HomeViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,XMLParserDelegate {
    
    @IBOutlet var viewAddCustomer: RSBorderView!
    @IBOutlet weak var txtCustName: RSTextField!
    @IBOutlet weak var txtCustNo: RSTextField!
    @IBOutlet weak var txtNoOfPax: RSTextField!
    @IBOutlet weak var tblCustomerList: UITableView!
    
    var dimView:UIView?
    var aryDispCustomerList : [AnyObject] = [AnyObject]()
    var strTemp : String = ""
    var strCustomerAccountID : String = "0"
    
    var strChkXML : String = ""
    var strResult = ""
    var finalVal : String = ""
    
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
                    self.serviceCallForCustomerExist(custNumber: strTemp)
                    //self.helperForCustomerExist(custNumber: strTemp)
                    
                } else {
                    self.strCustomerAccountID = "0"
                    self.txtCustName.text = ""
                }
            }
            else {
                strTemp = textField.text! + string
                
                if strTemp.characters.count == 10 {
                    self.serviceCallForCustomerExist(custNumber: strTemp)
                    //self.helperForCustomerExist(custNumber: strTemp)
                    
                } else {
                    self.strCustomerAccountID = "0"
                    self.txtCustName.text = ""
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
            customerListCell.btnDelete.tag = indexPath.row
            customerListCell.btnAssign.addTarget(self, action: #selector(self.btnAssignTableClick), for: .touchUpInside)
            customerListCell.btnDelete.addTarget(self, action: #selector(self.btnDeleteCustEntryClick), for: .touchUpInside)
            
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
        
        let position: CGPoint = sender.convert(.zero, to: tblCustomerList)
        let indexPath = self.tblCustomerList.indexPathForRow(at: position)
        
        if aryDispCustomerList.count > 0 {
            let dictItem : [String:AnyObject] = aryDispCustomerList[(indexPath?.row)!] as! [String:AnyObject]
            print(dictItem)
            
            let objAssignTableVC = self.storyboard?.instantiateViewController(withIdentifier: "AssignTableViewController") as! AssignTableViewController
            
            objAssignTableVC.selectedWaitingID = ResolutePOS.object_forKeyWithValidationForClass_String(dict: dictItem, key: "WaitingID")
            self.navigationController?.pushViewController(objAssignTableVC, animated: true)
        }
    }
    
    //MARK:- Button Click For Delete Selected Entry
    @objc func btnDeleteCustEntryClick(sender:UIButton) {
        print(sender.tag)
        
        // Get cell oultlets/Indexpath
        let position: CGPoint = sender.convert(.zero, to: tblCustomerList)
        let indexPath = self.tblCustomerList.indexPathForRow(at: position)
        
        if aryDispCustomerList.count > 0 {
            let dictItem : [String:AnyObject] = aryDispCustomerList[(indexPath?.row)!] as! [String:AnyObject]
            print(dictItem)
            
            let waitingId = ResolutePOS.object_forKeyWithValidationForClass_String(dict: dictItem, key: "WaitingID")
            print(waitingId)
            
            let alert = UIAlertController(title: "Resolute Pos", message: "Are you sure want to delete?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
                
                self.deleteCustomerEntryValue(strWaitingID: waitingId)
                self.serviceCallForDeleteEntry(waitingID: waitingId)
                
            }))
            self.present(alert, animated: true)
        }
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
            
            self.serviceCallForAddCustomer(actID: self.strCustomerAccountID, custNumber: txtCustNo.text!, actName: txtCustName.text!, noOfPax: txtNoOfPax.text!, locID: ResolutePOS.getLocationID(), compID:"1" )
            //self.insertCustomerHelper()
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
    
    //MARK:- Service Call For Customer Exist Or Not List
    func serviceCallForCustomerExist(custNumber:String) {
        if IS_INTERNET_AVAILABLE() {
            
            self.strChkXML = "CustomerListAPI"
            finalVal = ""
            
            var dicJ : [String:AnyObject] = [:]
            dicJ["CustomerCellNo"] = custNumber as AnyObject
            //dicJ["CustomerCellNo"] = "9512533376" as AnyObject
            print(dicJ) //["CustomerCellNo" : 9512533376]
            
            //Get JsonString From Dict
            let strResult = ResolutePOS.getJsonStringByDictionary(dict: dicJ)
            print(strResult) //{"DeviceID" : "6E43B9E1-4406-46A9-A705-77F975E951FB","TabID" : 10}
            
            let strUrl : String = CONSTANTS.APINAME.GetAllJsonData
            print("URL",strUrl)
            
            let headers: HTTPHeaders = [:]
            
            var parameter : [String:AnyObject] = [:]
            parameter["Procedure"] = "Waiting_Search_Customer" as AnyObject
            parameter["Json"] = "[\(strResult)]" as AnyObject
            print("PARAM",parameter)
            
            ServiceManager.sharedManager.postResponseWithHeader(strUrl, params: parameter, headers: headers, Loader: false) { (result) in
                print(result)  // <string xmlns="http://tempuri.org/">{"Table":[{"AccountID":83,"AccountName":"Resolute"}]}</string>
                
                do
                {
                    let data  = try Data(result.utf8)
                    let xml = XMLParser(data: data)
                    print(xml.description)
                    print(xml)
                    
                    xml.delegate = self
                    xml.parse()
                }
                catch
                {
                    RSAlertUtils.displayAlertWithMessage("Something was wrong....!")
                }
            }
        } else {
            RSAlertUtils.displayNoInternetMessage()
        }
    }
    
    //MARK:- Service Call For Add Customer List
    func serviceCallForAddCustomer(actID:String,custNumber:String,actName:String,noOfPax:String,locID:Int,compID:String) {
        if IS_INTERNET_AVAILABLE() {
            
            self.strChkXML = "AddCustomerAPI"
            finalVal = ""
            
            var userName : String = ""
            if ResolutePOS.getServer() != "" {
                userName = ResolutePOS.getServer()
            }
            
            var dicJ : [String:AnyObject] = [:]
            dicJ["AccountID"] = actID as AnyObject
            dicJ["CustomerCellNo"] = custNumber as AnyObject
            dicJ["AccountName"] = actName as AnyObject
            dicJ["NoOfPax"] = noOfPax as AnyObject
            dicJ["LocationID"] = locID as AnyObject
            dicJ["CompanyID"] = compID as AnyObject
            dicJ["UserName"] = userName as AnyObject
            print(dicJ) //["AccountID" : 1,"CustomerCellNo" : 1,"AccountName" : 1,"NoOfPax" : 1,"LocationID" : 1,"CompanyID" : 1,"UserName" : 1]
            
            //Get JsonString From Dict
            let strResult = ResolutePOS.getJsonStringByDictionary(dict: dicJ)
            print(strResult) //{"DeviceID" : "6E43B9E1-4406-46A9-A705-77F975E951FB","TabID" : 10}
            
            let strUrl : String = CONSTANTS.APINAME.GetAllJsonData
            print("URL",strUrl)
            
            let headers: HTTPHeaders = [:]
            
            var parameter : [String:AnyObject] = [:]
            parameter["Procedure"] = "Waiting_Add_Customer" as AnyObject
            parameter["Json"] = "[\(strResult)]" as AnyObject
            print("PARAM",parameter)
            
            ServiceManager.sharedManager.postResponseWithHeader(strUrl, params: parameter, headers: headers, Loader: false) { (result) in
                print(result)  // <string xmlns="http://tempuri.org/">{"Table":[{"AccountID":83,"WaitingID":"2"}]}</string>
                
                do
                {
                    let data  = try Data(result.utf8)
                    let xml = XMLParser(data: data)
                    print(xml.description)
                    print(xml)
                    
                    xml.delegate = self
                    xml.parse()
                }
                catch
                {
                    RSAlertUtils.displayAlertWithMessage("Something was wrong....!")
                }
            }
        } else {
            RSAlertUtils.displayNoInternetMessage()
        }
    }
    
    //MARK:- Service Call For Add Customer List
    func serviceCallForDeleteEntry(waitingID:String) {
        if IS_INTERNET_AVAILABLE() {
            
            self.strChkXML = "DeleteCustEntryAPI"
            finalVal = ""
            
            var dicJ : [String:AnyObject] = [:]
            dicJ["WaitingID"] = waitingID as AnyObject
            print(dicJ) //["WaitingID" : 1]
            
            //Get JsonString From Dict
            let strResult = ResolutePOS.getJsonStringByDictionary(dict: dicJ)
            print(strResult) //{"WaitingID" : "2"}
            
            let strUrl : String = CONSTANTS.APINAME.GetAllJsonData
            print("URL",strUrl)
            
            let headers: HTTPHeaders = [:]
            
            var parameter : [String:AnyObject] = [:]
            parameter["Procedure"] = "Waiting_Delete_Entry" as AnyObject
            parameter["Json"] = "[\(strResult)]" as AnyObject
            print("PARAM",parameter)
            
            ServiceManager.sharedManager.postResponseWithHeader(strUrl, params: parameter, headers: headers, Loader: false) { (result) in
                print(result)  // <string xmlns="http://tempuri.org/">{"Table":[{"AccountID":83,"AccountName":"Resolute"}]}</string>
                
                do
                {
                    let data  = try Data(result.utf8)
                    let xml = XMLParser(data: data)
                    print(xml.description)
                    print(xml)
                    
                    xml.delegate = self
                    xml.parse()
                }
                catch
                {
                    RSAlertUtils.displayAlertWithMessage("Something was wrong....!")
                }
            }
        } else {
            RSAlertUtils.displayNoInternetMessage()
        }
    }
    
    //MARK:- XML Methods
    func parserDidEndDocument(_ parser: XMLParser) {
        print(finalVal)
        
        if strChkXML == "CustomerListAPI" {
            if finalVal != "" {
                let responseData = ResolutePOS.convertStringToDictionary(text: finalVal)!
                print(responseData)
                
                //Check Array Nil Or Not
                if (ResolutePOS.checkArray(dict: responseData, key: "Table")) {
                    let aryCustList = responseData["Table"] as! [AnyObject]
                    
                    if aryCustList.count > 0 {
                        let dict : [String:AnyObject]  = aryCustList[0] as! [String:AnyObject]
                        print(dict)
                        
                        self.strCustomerAccountID = ResolutePOS.object_forKeyWithValidationForClass_String(dict: dict, key: "AccountID")
                        self.txtCustName.text = ResolutePOS.object_forKeyWithValidationForClass_String(dict: dict, key: "AccountName")
                        
                    } else {
                        self.strCustomerAccountID = "0"
                        self.txtCustName.text = ""
                    }
                }
            }
        }
        
        if strChkXML == "AddCustomerAPI" {
            if finalVal != "" {
                let responseData = ResolutePOS.convertStringToDictionary(text: finalVal)!
                print(responseData)
                
                //Check Array Nil Or Not
                if (ResolutePOS.checkArray(dict: responseData, key: "Table")) {
                    let aryCustList = responseData["Table"] as! [AnyObject]
                    
                    if aryCustList.count > 0 {
                        let dict : [String:AnyObject]  = aryCustList[0] as! [String:AnyObject]
                        print(dict)
                        
                        let strActID : String = ResolutePOS.object_forKeyWithValidationForClass_String(dict: dict, key: "AccountID")
                        let strWaitingID : String = ResolutePOS.object_forKeyWithValidationForClass_String(dict: dict, key: "WaitingID")
                        
                        self.insertCustomerHelper(custActID: strActID, waitingID: strWaitingID, custName: txtCustName.text!, custNumber: txtCustNo.text!, noOfPax: txtNoOfPax.text!)
                    }
                }
            }
        }
        
        if strChkXML == "DeleteCustEntryAPI" {
            if finalVal != "" {
                let responseData = ResolutePOS.convertStringToDictionary(text: finalVal)!
                print(responseData)
                
                //Check Array Nil Or Not
                if (ResolutePOS.checkArray(dict: responseData, key: "Table")) {
                    let aryCustList = responseData["Table"] as! [AnyObject]
                    
                    if aryCustList.count > 0 {
                        let dict : [String:AnyObject]  = aryCustList[0] as! [String:AnyObject]
                        print(dict)
                        
                        let strResult : String = ResolutePOS.object_forKeyWithValidationForClass_String(dict: dict, key: "Column1")
                        if strResult == "1" {
                            print("Success Deleted")
                        } else {
                            print("Something wrong into delete operation")
                        }
                    }
                }
            }
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        finalVal.append(strResult)
        print(finalVal)
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        print(string)
        strResult = string //{"Table":[{"FloorID":1,"FloorName":"Ground Floor","Height":"484","Width":"800"}]}
        print(strResult)
    }
    
    //MARK: Helper For Customer Exist Or Not
//    func helperForCustomerExist(custNumber:String) {
//
//        let query = String(format: "select * from CustomerMaster")
//        let aryCustList = obj.getDynamicTableData(query: query)
//
//        if aryCustList.count > 0 {
//            var aryFinalCustList : [AnyObject] = [AnyObject]()
//            for i in 0...aryCustList.count - 1 {
//
//                let dict:[String: AnyObject] = aryCustList[i] as! [String: AnyObject]
//                let mobileNo = ResolutePOS.object_forKeyWithValidationForClass_String(dict: dict, key: "ContactNo")
//
//                //Match Mobile No And Get list of Customer
//                if mobileNo == custNumber {
//                    aryFinalCustList.append(dict as AnyObject)
//
//                    if aryFinalCustList.count > 0 {
//                        let dict : [String:AnyObject] = aryFinalCustList[0] as! [String:AnyObject]
//                        self.strCustomerAccountID = ResolutePOS.object_forKeyWithValidationForClass_String(dict: dict, key: "ID")
//                        let strCustomerAccountName  = ResolutePOS.object_forKeyWithValidationForClass_String(dict: dict, key: "Name")
//                        self.txtCustName.text = strCustomerAccountName
//
//                    } else {
//                        self.strCustomerAccountID = "0"
//                    }
//                }
//            }
//        }
//    }
    
    //MARK:- Helper for Insert Customer
    func insertCustomerHelper(custActID:String,waitingID:String,custName:String,custNumber:String,noOfPax:String) {
        let query = "insert into CustomerMaster(customerActID,WaitingID,Name,ContactNo,NoOfPax,IsAssign)values('\(custActID)','\(waitingID)','\(custName)','\(custNumber)','\(noOfPax)','\("")')"
        _ = obj.dboperation(query: query)
        self.popUpHide(popupView: viewAddCustomer)
        self.setupCustData()
        self.helperForClearTextFieldData()
    }
    
    //MARK:- Delete Customer Entry
    func deleteCustomerEntryValue(strWaitingID:String) {
        
        let query = String(format: "delete from CustomerMaster where WaitingID = '%@'",strWaitingID)
        print(query)
        
        let st = obj.dboperation(query: query)
        
        if st == true
        {
            print("Delete successfully")
            self.setupCustData()
        }
        else
        {
            print("Not deleted")
        }
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

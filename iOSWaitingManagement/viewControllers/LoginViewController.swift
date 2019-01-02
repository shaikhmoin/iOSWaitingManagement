//
//  LoginViewController.swift
//  iOSWaitingManagement
//
//  Created by Akash on 12/27/18.
//  Copyright © 2018 Moin. All rights reserved.
//

import UIKit
import Alamofire

class LoginViewController: UIViewController,UITextFieldDelegate,XMLParserDelegate {
    
    @IBOutlet weak var btnStar1: RSButton!
    @IBOutlet weak var btnStar2: RSButton!
    @IBOutlet weak var btnStar3: RSButton!
    @IBOutlet weak var btnStar4: RSButton!
    @IBOutlet weak var txtIP: RSTextField!
    @IBOutlet var viewIPAddress: UIView!
    
    var count : Int = 0
    var strPin : String = ""
    var dimView:UIView?
    
    var arr = [Any]()
    var brr = [String]()
    var strResult = ""
    var finalVal : String = ""
    var strChkXML : String = ""
    
    //MARK:- UIView Life cycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
        self.addPropertyPopupFunctionForIPView()
        
        //Check Userdefault SERVER is Empty Or Not
        if ResolutePOS.getServer() == "" {
            popUpShow(popupView: viewIPAddress)
            txtIP.becomeFirstResponder()
        }
    }
    //MARK:- UITextfield Delegate Methods
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    //MARK:- Button Pin selction click
    @IBAction func btnPinSelectionClick(_ sender: UIButton) {
        
        if count < 4 {
            
            if (count == 0) {
                btnStar1.setTitle("*", for: .normal)
            } else if (count == 1) {
                btnStar2.setTitle("*", for: .normal)
            } else if (count == 2) {
                btnStar3.setTitle("*", for: .normal)
            } else {
                btnStar4.setTitle("*", for: .normal)
            }
            
            if strPin == "" {
                strPin = (sender.titleLabel?.text)!
            } else {
                
                strPin = strPin + (sender.titleLabel?.text)!
            }
            count = count + 1
            
            if count == 4 {
                self.serviceCallForLogin()
            }
        }
    }
    
    //MARK:- Button Clear click
    @IBAction func btnClearClick(_ sender: Any) {
        
        if (count != 0) {
            count = count - 1
            if (count == 3) {
                btnStar4.setTitle("", for: .normal)
            }
            else if (count == 2) {
                btnStar3.setTitle("", for: .normal)
            }
            else if (count == 1) {
                btnStar2.setTitle("", for: .normal)
            }
            else {
                btnStar1.setTitle("", for: .normal)
            }
            //Remove last digit of value
            strPin.remove(at:strPin.index(before:strPin.endIndex))
        }
    }
    
    //MARK:- Button Login click
    @IBAction func btnLoginClick(_ sender: Any) {
        self.serviceCallForLogin()
    }
    
    //MARK:- Button Connect IP click
    @IBAction func btnConnectIPClick(_ sender: Any) {
        if txtIP.text != "" {
            self.serviceCallForCheckServerConnection()
        } else {
            RSAlertUtils.displayAlertWithMessage("Please Enter IP Address first!")
        }
    }
    
    //MARK:- UIPopup helper methods
    func addPropertyPopupFunctionForIPView()  {
        
        strPin = ""
        count = 0
        
        btnStar1.setTitle("", for: .normal)
        btnStar2.setTitle("", for: .normal)
        btnStar3.setTitle("", for: .normal)
        btnStar4.setTitle("", for: .normal)
        
        self.view.addSubview(viewIPAddress)
        self.viewIPAddress.alpha = 0.0
        
        var popupWidth: Int = 0
        var popupHeight: Int = 0
        
        if ResolutePOS.DeviceType.IS_iPAD {
            popupWidth = 520
            popupHeight = 210
        } else {
            popupWidth = 300
            popupHeight = 180
        }
        
        var x:Int = Int(UIScreen.main.bounds.width)
        var y:Int = Int(UIScreen.main.bounds.height)
        
        x =  (x - Int(popupWidth)) / 2
        y = (y - Int(popupHeight)) / 2
        
        viewIPAddress.frame = CGRect(x: CGFloat(x), y: CGFloat(y), width: CGFloat(popupWidth), height: CGFloat(popupHeight))
        viewIPAddress.layoutIfNeeded()
        self.view.addSubview(viewIPAddress)
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
    
    //MARK:- Service call for IP check
    func serviceCallForCheckServerConnection() {
        if IS_INTERNET_AVAILABLE() {
            
            self.strChkXML = "ConnectIPAPI"
            finalVal = ""
            
            UserDefaults.standard.set( "http://" + self.txtIP.text! + "/", forKey: CONSTANTS.IPADDRESS)
            
            let strUrl : String = CONSTANTS.APINAME.checkIPAddress
            print("URL",strUrl)
            
            let headers: HTTPHeaders = [:]
            
            var parameter : [String:AnyObject] = [:]
            parameter["ProcName"] = "TabOrder_Get_Location_Counter" as AnyObject
            print("PARAM",parameter)
            
            ServiceManager.sharedManager.postResponseWithHeader(strUrl, params: parameter, headers: headers, Loader: false) { (result) in
                print(result)
                
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
        }
    }
    
    //MARK:- Service call for login
    func serviceCallForLogin() {
        if IS_INTERNET_AVAILABLE() {
            
            self.strChkXML = "LoginAPI"
            finalVal = ""
            
            let strUrl : String = CONSTANTS.APINAME.GetLoginDet
            print("URL",strUrl)
            
            let headers: HTTPHeaders = [:]
            
            var parameter : [String:AnyObject] = [:]
            parameter["Procedure"] = "TabOrder_Login" as AnyObject
            parameter["PIN"] = strPin as AnyObject
            print("PARAM",parameter)
            
            ServiceManager.sharedManager.postResponseWithHeader(strUrl, params: parameter, headers: headers, Loader: false) { (result) in
                print(result)
                
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
        }
    }
    
    //MARK:- XML Methods
    func parserDidStartDocument(_ parser: XMLParser) {
        arr = [Any]()
    }
    
    func parserDidEndDocument(_ parser: XMLParser) {
        print(finalVal)
        
        if strChkXML == "ConnectIPAPI" {
            if finalVal != "" {
                let responseData = ResolutePOS.convertStringToDictionary(text: finalVal)!
                
                //Check Array Nil Or Not
                if (ResolutePOS.checkArray(dict: responseData, key: "Table")) {
                    
                    let aryList = responseData["Table"] as! [AnyObject]
                    
                    if aryList.count > 0 {
                        self.popUpHide(popupView: self.viewIPAddress)
                        txtIP.resignFirstResponder()
                        RSAlertUtils.displayAlertWithMessage("You've Configured IP Address Successfully!")
                    }  else {
                        RSAlertUtils.displayAlertWithMessage("Oops. Please Check Your IP Address Again!")
                    }
                }
            } else {
                RSAlertUtils.displayAlertWithMessage("Oops. Please Check Your IP Address Again!")
            }
        }
        
        if strChkXML == "LoginAPI" {
            if finalVal != "" {
                let responseData = ResolutePOS.convertStringToDictionary(text: finalVal)!
                
                //Check Array Nil Or Not
                if (ResolutePOS.checkArray(dict: responseData, key: "Particular")) {
                    
                    let aryList = responseData["Particular"] as! [AnyObject]
                    
                    if aryList.count > 0 {
                        let dict : [String:AnyObject]  = aryList[0] as! [String:AnyObject]
                        
                        let userID = ResolutePOS.object_forKeyWithValidationForClass_String(dict: dict, key: "UserID")
                        let server = ResolutePOS.object_forKeyWithValidationForClass_String(dict: dict, key: "Server")
                        
                        if userID == "0" {
                            RSAlertUtils.displayAlertWithMessage("Please Enter Valid Pin!")
                        } else {
                            UserDefaults.standard.set(server, forKey: CONSTANTS.SERVER)
                            let nav = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
                            self.navigationController?.pushViewController(nav, animated: true)
                        }
                    }
                }
            } else {
                popUpShow(popupView: viewIPAddress)
            }
        }
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        if elementName == "string"
        {
            brr = [String]()
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        finalVal.append(strResult)
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        strResult = string
    }
}

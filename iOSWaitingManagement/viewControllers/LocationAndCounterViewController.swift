//
//  LocationAndCounterViewController.swift
//  iOSWaitingManagement
//
//  Created by Akash on 1/7/19.
//  Copyright © 2019 Moin. All rights reserved.

import UIKit
import Alamofire

class LocationAndCounterViewController: UIViewController,XMLParserDelegate {
    
    @IBOutlet weak var txtLocationList: RSTextField!
    @IBOutlet weak var txtCounterList: RSTextField!
    @IBOutlet weak var txtTabletList: RSTextField!
    
    var strChkXML : String = ""
    var strResult = ""
    var finalVal : String = ""
    
    var aryGloblalCounterList : [AnyObject] = [AnyObject]()
    var aryCounterList : [AnyObject] = [AnyObject]()
    var strDeviceid : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.isNavigationBarHidden = true
        
        txtLocationList.setTextFieldType(tFieldType: .Location)
        txtCounterList.setTextFieldType(tFieldType: .Counter)
        txtTabletList.setTextFieldType(tFieldType: .Tablet)
        
        self.serviceCallForLocationList()
        
        //Location List Done Click
        txtLocationList.didSelectLocation = { (selectedLocationID) in
            print("Selected Location ID :- \(selectedLocationID)")
            
            self.aryCounterList = []
            for i in 0...self.aryGloblalCounterList.count - 1 {
                
                let dict:[String: AnyObject] = self.aryGloblalCounterList[i] as! [String: AnyObject]
                print(dict)
                let locationId = ResolutePOS.object_forKeyWithValidationForClass_String(dict: dict, key: "LocationID")
                
                //Match Location ID And Get list of selected Counter All List Data
                if String(selectedLocationID) == String(locationId) {
                    print(dict)
                    self.aryCounterList.append(dict as AnyObject)
                    self.txtCounterList.setUpCounterList(data: self.aryCounterList)
                    self.serviceCallForRegisterDeviceList(strLocationID: String(selectedLocationID))
                }
            }
            
            if self.aryCounterList.count == 0 {
                self.txtCounterList.text = ""
                self.txtTabletList.text = ""
                self.txtCounterList.setUpCounterList(data: self.aryCounterList)
                self.serviceCallForRegisterDeviceList(strLocationID: String(selectedLocationID))
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    //MARK:- Button Close Click
    @IBAction func btnCloseClick(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK:- Button Set Click
    @IBAction func btnSetClick(_ sender: Any) {
        if self.txtLocationList.text == "" {
            RSAlertUtils.displayAlertWithMessage("Please select location first!")
            
        } else if self.txtCounterList.text == "" {
            RSAlertUtils.displayAlertWithMessage("Please select counter first!")
            
        } else if self.txtTabletList.text == "" {
            RSAlertUtils.displayAlertWithMessage("Please select tablet first!")
            
        }
            
        else {
            self.serviceCallForSaveDataToDeviceRegistration()
        }
    }
    
    //MARK:- Service call for Location List
    func serviceCallForLocationList() {
        if IS_INTERNET_AVAILABLE() {
            
            self.strChkXML = "LocationListAPI"
            finalVal = ""
            
            let strUrl : String = CONSTANTS.APINAME.checkIPAddressOrGetLocation
            print("URL",strUrl)
            
            let headers: HTTPHeaders = [:]
            
            var parameter : [String:AnyObject] = [:]
            parameter["ProcName"] = "TabOrder_Get_Location_Counter" as AnyObject
            print("PARAM",parameter)
            
            ServiceManager.sharedManager.postResponseWithHeader(strUrl, params: parameter, headers: headers, Loader: false) { (result) in
                print(result) //<string xmlns="http://tempuri.org/">{"Table":[{"LocationID":1,"LocationName":"Swiss Whisk"}]}</string>
                
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
    
    //MARK:- Service call for Register Device Data List
    func serviceCallForRegisterDeviceList(strLocationID:String) {
        if IS_INTERNET_AVAILABLE() {
            
            self.strChkXML = "RegisterDeviceListAPI"
            finalVal = ""
            
            var dicJ : [String:AnyObject] = [:]
            dicJ["LOCATIONID"] = strLocationID as AnyObject
            print(dicJ) //{"LOCATIONID" : "1"}
            
            //Get JsonString From Dict
            let strResult = ResolutePOS.getJsonStringByDictionary(dict: dicJ)
            print(strResult) //[{"DeviceID" : "6E43B9E1-4406-46A9-A705-77F975E951FB","TabID" : 10}]
            
            let strUrl : String = CONSTANTS.APINAME.GetAllJsonData
            print("URL",strUrl)
            
            let headers: HTTPHeaders = [:]
            
            var parameter : [String:AnyObject] = [:]
            parameter["Procedure"] = "TabOrder_Get_Tablet" as AnyObject
            parameter["Json"] = "[\(strResult)]" as AnyObject
            //parameter["Json"] = "\(arrVal)" as AnyObject
            print("PARAM",parameter)
            
            ServiceManager.sharedManager.postResponseWithHeader(strUrl, params: parameter, headers: headers, Loader: false) { (result) in
                print(result) //<string xmlns="http://tempuri.org/">{"Table":[{"FloorID":1,"FloorName":"Ground Floor","Height":"484","Width":"800"}]}</string>
                
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
    
    //MARK:- Service call for Save Data To Device Registration
    func serviceCallForSaveDataToDeviceRegistration() {
        if IS_INTERNET_AVAILABLE() {

            self.strChkXML = "SaveDataToDeviceRegistrationAPI"
            finalVal = ""
            
            strDeviceid = (UIDevice.current.identifierForVendor?.uuidString)!
            
            var dicJ : [String:AnyObject] = [:]
            dicJ["TabID"] = APPDELEGATE.strSelectedTabletID as AnyObject
            dicJ["DeviceID"] = strDeviceid as AnyObject
            print(dicJ) //{"DeviceID" : "6E43B9E1-4406-46A9-A705-77F975E951FB","TabID" : 10}
            
            //Get JsonString From Dict
            let strResult = ResolutePOS.getJsonStringByDictionary(dict: dicJ)
            print(strResult) //[{"DeviceID" : "6E43B9E1-4406-46A9-A705-77F975E951FB","TabID" : 10}]
            
            let strUrl : String = CONSTANTS.APINAME.GetAllJsonData
            print("URL",strUrl)
            
            let headers: HTTPHeaders = [:]
            
            var parameter : [String:AnyObject] = [:]
            parameter["Procedure"] = "TabOrder_Tablet_Save" as AnyObject
            parameter["Json"] = "[\(strResult)]" as AnyObject
            print("PARAM",parameter)
            
            ServiceManager.sharedManager.postResponseWithHeader(strUrl, params: parameter, headers: headers, Loader: false) { (result) in
                print(result) //<string xmlns="http://tempuri.org/">{"Table":[{"FloorID":1,"FloorName":"Ground Floor","Height":"484","Width":"800"}]}</string>
                
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
        
        if strChkXML == "LocationListAPI" {
            if finalVal != "" {
                let responseData = ResolutePOS.convertStringToDictionary(text: finalVal)!
                print(responseData)
                
                //Check Array Nil Or Not
                if (ResolutePOS.checkArray(dict: responseData, key: "Table")) {
                    let aryGloblalLocationList = responseData["Table"] as! [AnyObject]
                    
                    if aryGloblalLocationList.count > 0 {
                        
                        if (ResolutePOS.checkArray(dict: responseData, key: "Table1")) {
                            aryGloblalCounterList = responseData["Table1"] as! [AnyObject]
                            print(aryGloblalCounterList)
                        }
                        self.txtLocationList.setUpLocationList(data: aryGloblalLocationList)
                    }
                }
            }
        }
        
        if strChkXML == "RegisterDeviceListAPI" {
            if finalVal != "" {
                let responseData = ResolutePOS.convertStringToDictionary(text: finalVal)!
                print(responseData)
                
                //Check Array Nil Or Not
                if (ResolutePOS.checkArray(dict: responseData, key: "Table")) {
                    let aryGlobalTabList = responseData["Table"] as! [AnyObject]
                    self.txtTabletList.setUpTabletList(data: aryGlobalTabList)
                }
            }
        }
        
        if strChkXML == "SaveDataToDeviceRegistrationAPI" {
            if finalVal != "" {
                let responseData = ResolutePOS.convertStringToDictionary(text: finalVal)!
                print(responseData)
                
                //Check Array Nil Or Not
                if (ResolutePOS.checkArray(dict: responseData, key: "Table")) {
                    let aryResult = responseData["Table"] as! [AnyObject]
                    
                    if aryResult.count > 0 {
                        let dict : [String:AnyObject]  = aryResult[0] as! [String:AnyObject]
                        print(dict)
                        
                        let strResult = ResolutePOS.object_forKeyWithValidationForClass_String(dict: dict, key: "Result")
                        
                        if strResult == "1" {
                            print(APPDELEGATE.dictSelectedTab)
                            UserDefaultFunction.setCustomDictionary(dict: APPDELEGATE.dictSelectedTab, key: CONSTANTS.SELECTEDTABDETAIL)
                            
                            UserDefaults.standard.set(strDeviceid, forKey: CONSTANTS.DEVICEID)
                            UserDefaults.standard.set(APPDELEGATE.strSelectedLocationID, forKey: CONSTANTS.LOCATIONID)
                            UserDefaults.standard.set(APPDELEGATE.strSelectedCounterID, forKey: CONSTANTS.COUNTERID)
                            UserDefaults.standard.set(APPDELEGATE.strSelectedTabletID, forKey: CONSTANTS.TABLETID)
                            
                            let alert = UIAlertController(title: "Resolute Pos", message: "Please Wait Till Device Get Approved.", preferredStyle: .alert)
                            
                            alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
                                exit(0)
                            }))
                            self.present(alert, animated: true)
                        }
                        
                    } else {
                        RSAlertUtils.displayAlertWithMessage("Sorry, No Records Found.")
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
}

//
//  AssignTableViewController.swift
//  iOSWaitingManagement
//
//  Created by Akash on 12/29/18.
//  Copyright © 2018 Moin. All rights reserved.
//

import UIKit
import Alamofire

class AssignTableViewController: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,XMLParserDelegate {
    
    @IBOutlet weak var cltnTableList: UICollectionView!
    @IBOutlet weak var txtFloorList: RSTextField!
    
    var localDict: [String: AnyObject] = [:]
    var aryGloblalFloorList: [AnyObject] = [AnyObject]()
    var aryGloblalTableList: [AnyObject] = [AnyObject]()
    
    var strChkXML : String = ""
    var strResult = ""
    var finalVal : String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        cltnTableList.dataSource = self
        cltnTableList.delegate = self
        
        self.cltnTableList.register(UINib(nibName:"AssignTableCollectionViewCelliPhone", bundle: nil), forCellWithReuseIdentifier: CONSTANTS.ID_ASSIGN__TABLE_LIST_COLLECTION_CELL_IPHONE)
        
        txtFloorList.setTextFieldType(tFieldType: .Floor)
        self.serviceCallForFloorList()
        
        //Category Mapping Floor List Done Click
        txtFloorList.didSelectFloor = { (selectedFloorID) in
            print("Selected Floor ID :- \(selectedFloorID)")
            self.serviceCallForTableList()
        }
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
    
    //MARK:- UICollection View Datasource Methods
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return aryGloblalTableList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let AssignTableCell = cltnTableList.dequeueReusableCell(withReuseIdentifier: CONSTANTS.ID_ASSIGN__TABLE_LIST_COLLECTION_CELL_IPHONE, for: indexPath) as! AssignTableCollectionViewCelliPhone
        
        AssignTableCell.applyShadowDefault()
        AssignTableCell.viewMain.applyShadowDefault()
        
        if aryGloblalTableList.count > 0 {
            AssignTableCell.setUpTableData(modelData: aryGloblalTableList[indexPath.row] as! [String:AnyObject])
        }
        return AssignTableCell
    }
    
    //MARK:- UiCollection view Delegates Methods
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    //MARK:- UICollectionview Flowlayout Methods
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = collectionView.frame.size.width
        if IS_IPAD_DEVICE()  {
            return CGSize(width: (width/4) - 20, height:180)
        } else {
            return CGSize(width: (width/2) - 10, height:180)
        }
    }
    
    //MARK:- Button Close Page Click
    @IBAction func btnCloseClick(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK:- Service Call For Floor List
    func serviceCallForFloorList() {
        if IS_INTERNET_AVAILABLE() {
            
            self.strChkXML = "FloorListAPI"
            finalVal = ""
            
            let locID = ("{LOCATIONID:\(1)")
            let CountID = ("COUNTERID:\(1)}")
            
            //PinID And Loc ID for combine values like dict
            var name = ""
            name.append(locID + "," + CountID)
            print(name)
            
            //Append LocID And CounterID into Array like [{LOCATIONID:1,COUNTERID:1}]
            var arrVal : [AnyObject] = [AnyObject]()
            arrVal.append(name as AnyObject)
            print(arrVal)
            
            let strUrl : String = CONSTANTS.APINAME.GetFloorListOrDevice
            print("URL",strUrl)
            
            let headers: HTTPHeaders = [:]
            
            var parameter : [String:AnyObject] = [:]
            parameter["Procedure"] = "TabOrder_Get_FloorTable" as AnyObject
            parameter["Json"] = "\(arrVal)" as AnyObject
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
    
    //MARK:- Service Call For Table List
    func serviceCallForTableList() {
        if IS_INTERNET_AVAILABLE() {
            
            self.strChkXML = "TableListAPI"
            finalVal = ""
            
            let strUrl : String = CONSTANTS.APINAME.GetTableList
            print("URL",strUrl)
            
            let headers: HTTPHeaders = [:]
            
            var parameter : [String:AnyObject] = [:]
            parameter["LocationID"] = "1" as AnyObject
            parameter["FloorID"] = APPDELEGATE.strSelectedFloorID as AnyObject
            parameter["Procedure"] = "TabOrder_Get_Table_IDWise" as AnyObject
            print("PARAM",parameter)
            
            ServiceManager.sharedManager.postResponseWithHeader(strUrl, params: parameter, headers: headers, Loader: false) { (result) in
                print(result) //<string xmlns="http://tempuri.org/">{"Table":[{"TableID":1,"TableName":"Table 1","TableNo":1,"NoOfPax":5,"OrderID":49247,"OrderNumber":10530,"NoOfItem":7,}</string>
                
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
        print("Hello first")
        print(finalVal)
        
        if strChkXML == "FloorListAPI" {
            if finalVal != "" {
                let responseData = ResolutePOS.convertStringToDictionary(text: finalVal)!
                
                //Check Array Nil Or Not
                if (ResolutePOS.checkArray(dict: responseData, key: "Table")) {
                    aryGloblalFloorList = responseData["Table"] as! [AnyObject]
                    
                    if aryGloblalFloorList.count > 0 {
                        self.txtFloorList.setUpFloorList(data: self.aryGloblalFloorList)
                    }
                }
            }
        }
        
        if strChkXML == "TableListAPI" {
            print("Hello final")
            print(finalVal)
            if finalVal != "" {
                let responseData = ResolutePOS.convertStringToDictionary(text: finalVal)!
                
                //Check Array Nil Or Not
                if (ResolutePOS.checkArray(dict: responseData, key: "Table")) {
                    
                    aryGloblalTableList = responseData["Table"] as! [AnyObject]
                    self.cltnTableList.reloadData()
                }
            }
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        finalVal.append(strResult)
        print(finalVal)
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        print("First Check")
        print(string)
        strResult = string //{"Table":[{"FloorID":1,"FloorName":"Ground Floor","Height":"484","Width":"800"}]}
        print(strResult)
    }
}

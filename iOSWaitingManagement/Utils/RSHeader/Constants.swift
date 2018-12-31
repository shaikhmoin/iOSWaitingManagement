//
//  Constants.swift
//  iOSWaitingManagement
//
//  Created by Akash on 12/27/18.
//  Copyright © 2018 Moin. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import NVActivityIndicatorView

struct CONSTANTS {
    
    // MARK: - Get Common Value
    static let appType  = "ios"
    static let appVersion  = Bundle.main.infoDictionary?["CFBundleShortVersionString"]!
    static let deviceName  = UIDevice.current.model
    static let systemVersion  = UIDevice.current.systemVersion
    
    // MARK: - userDefault Name
    static let USERACCOUNT = "userAccount"
    static let DEVICEID = "notification_key"
    static let USERID = "USERID"
    static let AUTHTOKEN  = "AUTHTOKEN"
    static let CURRENCY = "CURRENCY"
    static let SERVER = "SERVER"
    static let IPADDRESS = "IPADDRESS"
    
    //MARK: Local APP ID & Secret
    static let appId  = "f73952739412294a1951df7dd11fa3d3"
    static let appSecret  = "d1ebadd478df8afed3595ac93812a1dc"
    static let applicationJson  = "application/json"
    static let ContentType = "Content-Type"
    
    struct BASE_URL {
        
        //LOCAL
        static let IP = "http://192.168.0.100/"
        static let mainUrl = "ANDR/Service1.asmx/"
        
        //http://103.35.123.102/RESTAPI/Service1.asmx/GetAllJsonData?Procedure=TabOrder_Login&Json=[{PIN:1234}]
    }
    
    struct APINAME {
        static let checkIPAddress = "GetAllDataDataSet"
        static let GetLoginDet = "GetLoginDet"
        static let GetFloorList = "GetAllJsonData"
        static let GetTableList = "GetTables"
    }
    
    //Device
    struct QUERY_STRING {
        static func queryString()-> String {
            var strQuery:String = "app_type=\(CONSTANTS.appType)&app_version=\(CONSTANTS.appVersion!)&device_name=\(CONSTANTS.deviceName)&system_version=\(CONSTANTS.systemVersion)"
            strQuery = strQuery.replacingOccurrences(of: " ", with: "%20")
            return strQuery
        }
    }
    
    //MARK: UITableViewCell IDENTIFIER
    static let ID_CUSTOMR_LIST_TABLE_CELL = "CustomerListTableViewCell"
    static let ID_CUSTOMR_SUGGESTION_LIST_TABLE_CELL = "CustomerSuggestionTableViewCell"
    
    //MARK: UICllectionViewCell IDENTIFIER
    static let ID_ASSIGN__TABLE_LIST_COLLECTION_CELL = "AssignTableCollectionViewCell"
    
    //MARK: TRY AT HOME COLORS
    static let APP_PRIMARY_LIGHT_COLOR = "#4BB9DA"
    static let APP_MAIN_HOME_BUTTON_COLOR = "#70D2E2"    
}

//MARK: - MANAGERS
//let ValidationManager = TIValidationManager.sharedManager

//MARK: - APP SPECIFIC
let APP_NAME = "RePOS"

//MARK: - SCREEN SIZE
let NAVIGATION_BAR_HEIGHT: CGFloat = 64
let SCREEN_HEIGHT = UIScreen.main.bounds.size.height
let SCREEN_WIDTH = UIScreen.main.bounds.size.width

let CLEAR_COLOR = UIColor.clear
let WHITE_COLOR = UIColor.white
let BLACK_COLOR = UIColor.black
let RED_COLOR = UIColor.red
let GRAY_COLOR = UIColor.darkGray
let GREEN_COLOR = UIColor.green
let SELECTED_COLOR = UIColor.cyan

// MARK: - PRIMARY COLORS
let COLOR_TEXT_FIELD_SEPARATOR = UIColor.lightGray
let COLOR_THEME_GREEN = UIColor(red: 19, green: 121, blue: 52)
let COLOR_THEME_ORANGE = UIColor(red: 243, green: 111, blue: 36)
let COLOR_THEME_LIGHT_GRAY = UIColor(red: 250, green: 250, blue: 250)
let COLOR_THEME_BROWN = UIColor(red: 65, green: 41, blue: 27)
let COLOR_THEME_LIGHT_BROWN = UIColor(red: 193, green: 166, blue: 150)
let COLOR_THEME_BLACK = UIColor.black

func GET_PROPORTIONAL_WIDTH (_ width:CGFloat) -> CGFloat {
    return ((SCREEN_WIDTH * width)/750)
}
func GET_PROPORTIONAL_HEIGHT (_ height:CGFloat) -> CGFloat {
    return ((SCREEN_HEIGHT * height)/1334)
}

func GET_PROPORTIONAL_WIDTH_CELL (_ width:CGFloat) -> CGFloat {
    return ((SCREEN_WIDTH * width)/750)
}

func GET_PROPORTIONAL_HEIGHT_CELL (_ height:CGFloat) -> CGFloat {
    return ((SCREEN_WIDTH * height)/750)
}

// MARK: - INTERNET CHECK
func IS_INTERNET_AVAILABLE() -> Bool{
    return RSReachabilityManager.sharedManager.isInternetAvailableForAllNetworks()
}

//MARK:- DEVICE CHECK
//Check IsiPhone Device
func IS_IPHONE_DEVICE()->Bool{
    let deviceType = UIDevice.current.userInterfaceIdiom == .phone
    return deviceType
}

//Check IsiPad Device
func IS_IPAD_DEVICE()->Bool{
    let deviceType = UIDevice.current.userInterfaceIdiom == .pad
    return deviceType
}

//iPhone 4 OR 4S
func IS_IPHONE_4_OR_4S()->Bool{
    let SCREEN_HEIGHT_TO_CHECK_AGAINST:CGFloat = 480
    var device:Bool = false
    
    if(SCREEN_HEIGHT_TO_CHECK_AGAINST == SCREEN_HEIGHT)    {
        device = true
    }
    return device
}

//iPhone 5 OR OR 5C OR 4S
func IS_IPHONE_5_OR_5S()->Bool{
    let SCREEN_HEIGHT_TO_CHECK_AGAINST:CGFloat = 568
    var device:Bool = false
    if(SCREEN_HEIGHT_TO_CHECK_AGAINST == SCREEN_HEIGHT)    {
        device = true
    }
    return device
}

//iPhone 6 OR 6S
func IS_IPHONE_6_OR_6S()->Bool{
    let SCREEN_HEIGHT_TO_CHECK_AGAINST:CGFloat = 667
    var device:Bool = false
    
    if(SCREEN_HEIGHT_TO_CHECK_AGAINST == SCREEN_HEIGHT)    {
        device = true
    }
    return device
}

//iPhone 6Plus OR 6SPlus
func IS_IPHONE_6P_OR_6SP()->Bool{
    let SCREEN_HEIGHT_TO_CHECK_AGAINST:CGFloat = 736
    var device:Bool = false
    
    if(SCREEN_HEIGHT_TO_CHECK_AGAINST == SCREEN_HEIGHT)    {
        device = true
    }
    return device
}

//MARK:- DEVICE ORIENTATION CHECK
func IS_DEVICE_PORTRAIT() -> Bool {
    return UIDevice.current.orientation.isPortrait
}

func IS_DEVICE_LANDSCAPE() -> Bool {
    return UIDevice.current.orientation.isLandscape
}

class ResolutePOS: NSObject {
    
    class func startLoader() {
        let activityData = ActivityData()
        NVActivityIndicatorPresenter.sharedInstance.startAnimating(activityData)
    }
    
    class func stopLoader() {
        NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
    }
    
    class func getServer() -> String {
        var str : String = ""
        if let strServer = UserDefaults.standard.object(forKey: CONSTANTS.SERVER){
            str = strServer as! String
        }
        else {
            // not exist
        }
        return str
    }
    
    class func getcurrentDate() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let strCurrentDate: String = formatter.string(from: Date())
        return strCurrentDate
    }
    
    class func getOrderMenu() -> [String] {
        let arrMenu: [String] = ["DASHBOARD",  "NEW ORDERS", "PREPARING ORDERS", "COMEPLETED"]
        return arrMenu
    }
    
    struct ScreenSize
    {
        static let SCREEN_WIDTH         = UIScreen.main.bounds.size.width
        static let SCREEN_HEIGHT        = UIScreen.main.bounds.size.height
        static let SCREEN_MAX_LENGTH    = max(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
        static let SCREEN_MIN_LENGTH    = min(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
    }
    
    struct DeviceType
    {
        static let IS_IPHONE_4_OR_LESS  = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH < 568.0
        static let IS_IPHONE_5          = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 568.0
        static let IS_IPHONE_6_7          = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 667.0
        static let IS_IPHONE_6P_7P         = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 736.0
        static let IS_IPAD              = UIDevice.current.userInterfaceIdiom == .pad && ScreenSize.SCREEN_MAX_LENGTH == 1024.0
        static let IS_IPAD_PRO          = UIDevice.current.userInterfaceIdiom == .pad && ScreenSize.SCREEN_MAX_LENGTH == 1366.0
    }
    
    class func getStoryBoard() -> UIStoryboard {
        let storyBoard: UIStoryboard!
        
        if DeviceType.IS_IPAD {
            storyBoard = UIStoryboard(name: "iPad", bundle: nil)
        } else {
            storyBoard = UIStoryboard(name: "Main", bundle: nil)
        }
        
        return storyBoard
    }
    
    //NULL KEY CHECK
    class func object_forKeyWithValidationForClass_String(dict: [String: AnyObject], key: String) -> String
    {
        var strValue: String = ""
        if (dict[key] as? String) != nil  {
            strValue = dict[key] as! String
        }else if (dict[key] as? String) == "0" {
            strValue = "0"
        }
        else if (dict[key] as? Int) != nil {
            strValue = "\(dict[key] as! Int)"
        }
        else {
            strValue = ""
        }
        return strValue
    }
    
    //CHECK DICTIONARY
    static func checkDict(dict: [String: AnyObject], key: String) -> Bool {
        
        if (dict[key] as? [String:AnyObject]) != nil  {
            return true
        } else {
            return false
        }
    }
    
    //CHECK ARRAY
    static func checkArray(dict: [String: AnyObject], key: String) -> Bool {
        
        if (dict[key] as? [AnyObject]) != nil  {
            return true
        } else {
            return false
        }
    }
    
    //MARK:- Helper for string To Dictionary //{"Particular":[{"UserID":17,"Server":"harsan"}]}
    static func convertStringToDictionary(text: String) -> [String:AnyObject]? {
        if let data = text.data(using: String.Encoding.utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options:.allowFragments) as? [String:AnyObject]
            } catch let error as NSError {
                print(error)
            }
        }
        return nil
    }
    
    //DATE FROM STRING
    class func getDateFromString(date : String) -> String {
        
        print(date)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dateFromString = dateFormatter.date(from: date)
        dateFormatter.dateFormat = "dd-MM-yyyy"
        let result = dateFormatter.string(from: dateFromString!)
        print(result)
        return result
    }
    
    //Time From String
    class func getTimeFromString(date : String) -> String {
        print(date)
        if date != "" {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let dateFromString = dateFormatter.date(from: date)
            dateFormatter.dateFormat = "HH:mm:ss"
            let result = dateFormatter.string(from: dateFromString!)
            print(result)
            return result
        }
        return ""
    }
    
    class func dateFromStringWithDate(strDate : String) -> String {
        print(strDate)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateFromString = dateFormatter.date(from: strDate)
        print(dateFromString ?? "")
        dateFormatter.dateFormat = "dd.MMM.yyyy"
        let result = dateFormatter.string(from: dateFromString!)
        print(result)
        return result
    }
    
    class func dateFromStringWithTime(strDate : String) -> String {
        print(strDate)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        let dateFromString = dateFormatter.date(from: strDate)
        print(dateFromString ?? "")
        dateFormatter.dateFormat = "HH:mm"
        let result = dateFormatter.string(from: dateFromString!)
        print(result)
        return result
    }
    
    //MARK: getTodayDate
    class func getTodayDate() -> String {
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MMM.yyyy"
        let result = formatter.string(from: date)
        return result
    }
    
    //MARK: getTodayDateWith "dd MMMM YYYY" Format
    class func getTodayDateWithMonthFullTextFormat() -> String {
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMMM YYYY"
        let result = formatter.string(from: date)
        return result
    }
    
    //MARK: getTodayDateWithFullFormat
    class func getTodayDateWithFullFormat() -> String {
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy hh:mm a"
        let result = formatter.string(from: date)
        return result
    }
    
    class func HeightforLabel(text: String, font: UIFont, maxSize: CGSize) -> CGFloat {
        let attrString = NSAttributedString.init(string: text, attributes: [NSAttributedStringKey.font:font])
        let rect = attrString.boundingRect(with: maxSize, options: NSStringDrawingOptions.usesLineFragmentOrigin, context: nil)
        let size = CGSize(width: rect.width, height: rect.height)
        return size.height
    }
}

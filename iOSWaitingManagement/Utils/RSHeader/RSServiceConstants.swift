//
//  RSServiceConstants.swift
//  iOSWaitingManagement
//
//  Created by Akash on 12/27/18.
//  Copyright © 2018 Moin. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import NVActivityIndicatorView

//MARK: - HTTP MANAGER DELEGATE
@objc protocol ServiceManagerDelegate{
    func httpResponceData(dictionary:NSMutableDictionary,manager:ServiceManager)
    @objc optional  func httpFailed(dictionary:NSMutableDictionary,error:ServiceManager)
}

class ServiceManager: NSObject {
    
    var delegat : ServiceManagerDelegate?
    var activityIndicatorView : NVActivityIndicatorView!
    var window: UIWindow?
    
    static let sharedManager : ServiceManager = {
        let instance = ServiceManager()
        return instance
    }()
    
    //MARK: - GET RESPONSE
    func getResponse(_ url : String, param : [String: Any] ,headers: HTTPHeaders, completionHandler : @escaping (AnyObject) -> ())
    {
        startLoader()
        
        var strUrl : String = ""
        strUrl = CONSTANTS.BASE_URL.mainUrl + (url as String)
        
        print(strUrl)
        print(param)
        print(headers)
        
        Alamofire.request(strUrl, method: .get, parameters: param, encoding: URLEncoding.default, headers: headers).responseJSON { (response:DataResponse<Any>) in
            print(response.request!)
            
            switch(response.result) {
            case .success(_):
                
                self.stopLoader()
                
                print(response.result.value!)
                
                if response.result.value != nil{
                    
                    var result : [String:AnyObject] = [String:AnyObject]()
                    result = response.result.value as! [String:AnyObject]
                    print("RESULT",result)
                    
                    completionHandler(result as AnyObject)
                }
                break
                
            case .failure(_):
                self.stopLoader()
                print(response.result.error as Any)
                break
            }
        }
    }
    
    //MARK: - POST RESPONSE
    func postResponse(_ url : String, params : [String : Any],headers: HTTPHeaders, completionHandler :@escaping (AnyObject) -> ())
    {
        startLoader()
        
        var strUrl : String = ""
        strUrl = CONSTANTS.BASE_URL.mainUrl + (url as String)
        //+ CONSTATNS.QUERY_STRING.queryString()
        let queryString = CONSTANTS.QUERY_STRING.queryString()
        print(queryString)
        
        print(strUrl)
        print(params)
        print(headers)
        
        strUrl = strUrl + queryString
        print(strUrl)
        
        let temp = Alamofire.SessionManager.default
        temp.session.configuration.timeoutIntervalForRequest = 15.151
        
        Alamofire.request(strUrl, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers).responseJSON { (response:DataResponse<Any>) in
            
            print(strUrl)
            print(params)
            print(response.result)
            
            switch(response.result) {
            case .success(_):
                self.stopLoader()
                
                print(response.result.value!)
                if response.result.value != nil{
                    
                    var result : [String:AnyObject] = [String:AnyObject]()
                    result = response.result.value as! [String:AnyObject]
                    print("RESULT",result)
                    
                    let status : String = ResolutePOS.object_forKeyWithValidationForClass_String(dict: result, key: "Success")
                    if status == "ok"
                    {
                        completionHandler(result as AnyObject)
                    }
                    else
                    {
                        completionHandler(result as AnyObject)
                        //let message : String = PureiCook.object_forKeyWithValidationForClass_String(dict: result, key: "message")
                        //PIAlertUtils.displayAlertWithMessage(message)
                    }
                }
                break
                
            case .failure(let error):
                self.stopLoader()
                
                if error._code == NSURLErrorTimedOut {
                    //HANDLE TIMEOUT HERE
                }
                print("\n\nAuth request failed with error:\n \(error)")
                
                print(response.result.error as Any)
                break
            }
        }
    }
    
    
    func postResponseWithHeader(_ url : String, params : [String : Any],headers: HTTPHeaders,Loader:Bool, completionHandler :@escaping (String) -> ())
    {
        if Loader == false {
            startLoader()
        } else {
            stopLoader()
        }
        
        var strUrl : String = ""
        strUrl = url
        
        print(url)
        print(CONSTANTS.BASE_URL.IP)
        print(CONSTANTS.BASE_URL.mainUrl)
        
        //Set IPAddress from userdefault Or Not
        if (UserDefaults.standard.object(forKey: CONSTANTS.IPADDRESS) != nil) {
            let strIP = (UserDefaults.standard.object(forKey: CONSTANTS.IPADDRESS) ?? "dd") as! String
            strUrl = strIP + CONSTANTS.BASE_URL.mainUrl + (url as String)
        } else {
            strUrl = CONSTANTS.BASE_URL.IP + CONSTANTS.BASE_URL.mainUrl + (url as String)
        }
        
        print(strUrl) //http://192.168.0.100/ANDR/Service1.asmx/GetLoginDet
        print(params)
        print(headers)
        
        let temp = Alamofire.SessionManager.default
        temp.session.configuration.timeoutIntervalForRequest = 15.151
        
        Alamofire.request(strUrl, method: .post, parameters: params, encoding:URLEncoding.default, headers: headers).responseString { (response:DataResponse<String>) in
            
            print(strUrl)
            print(params)
            print(response.result)
            
            switch(response.result) {
            case .success(_):
                self.stopLoader()
                
                print(response.result.value!)

                if response.result.value != nil{
                    
//                    var result = response.result.value! as! String
//                    print("RESULT",result)
                    
                    var result : [String:AnyObject] = [String:AnyObject]()
                    var result2 = response.result.value
                    print("RESULT",result)
                    
//                    let d  = try Data(response.result.value.utf8)
//                    let xml = XMLParser(data: d)
//                    print(xml)
//                    xml.delegate = self
//                    xml.parse()
                    
                    //let status : String = ResolutePOS.object_forKeyWithValidationForClass_String(dict: result, key: "status")
                    //let code : String = ResolutePOS.object_forKeyWithValidationForClass_String(dict: result, key: "code")
                    
                    //                    if code == "401"
                    //                    {
                    //                        UserDefaults.standard.removeObject(forKey: CONSTANTS.POCID)
                    //                        UserDefaults.standard.removeObject(forKey: CONSTANTS.ADMINEMAIL)
                    //                        UserDefaults.standard.removeObject(forKey: CONSTANTS.LOCATIONID)
                    //                        UserDefaults.standard.removeObject(forKey: CONSTANTS.AUTHTOKEN)
                    //
                    //                        UserDefaults.standard.removeObject(forKey: CONSTANTS.DISPLAYNAME)
                    //                        UserDefaults.standard.removeObject(forKey: CONSTANTS.SUBDOMAIN)
                    //
                    //                        UserDefaults.standard.removeObject(forKey: CONSTANTS.POCENABLE)
                    //                        UserDefaults.standard.removeObject(forKey: CONSTANTS.POSENABLE)
                    //                        UserDefaults.standard.removeObject(forKey: CONSTANTS.CURRENCY)
                    //
                    //                        APPDELEGATE.openLoginPage()
                    //                        //PIAlertUtils.displayAlertWithMessage("You are already Logged in other device..!")
                    //                    }
                    //                    if status == "ok"
                    //                    {
                    completionHandler(result2 as! String)
                    //                    }
                    //                    else
                    //                    {
                    //                        completionHandler(result as AnyObject)
                    //                        let message : String = ResolutePOS.object_forKeyWithValidationForClass_String(dict: result, key: "message")
                    //                        //TIAlertutils.displayAlertWithMessage(message)
                    //                    }
                }
                break
                
            case .failure(let error):
                self.stopLoader()
                
                if error._code == NSURLErrorTimedOut {
                    //HANDLE TIMEOUT HERE
                }
                print("\n\nAuth request failed with error:\n \(error)")
                print(response.result.error as Any)
                RSAlertUtils.displayAlertWithMessage("Oops Somethings Was Wrong Please Try Again!")
                break
            }
        }
    }
    
    //MULTI PART DATA
    func postMultipartResponse(_ url : String, params : [String : Any],headers: HTTPHeaders, imageFile : UIImage, completionHandler :@escaping (AnyObject) -> ())
    {
        startLoader()
        
        var strUrl : String = ""
        strUrl = CONSTANTS.BASE_URL.mainUrl + (url as String)
        
        let imageData = UIImageJPEGRepresentation(imageFile , 0.5)
        let pageURL = "\(strUrl)/dataIOS/add"
        
        print(strUrl)
        print(params)
        print(headers)
        
        let temp = Alamofire.SessionManager.default
        temp.session.configuration.timeoutIntervalForRequest = 15.151
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            for (key, value) in params {
                multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key)
            }
            
            multipartFormData.append(imageData!, withName: "upload_photo", fileName: "img.png", mimeType: "image/jpeg")
        }, to:pageURL)
        { (result) in
            switch result {
            case .success(let upload, _, _):
                
                upload.uploadProgress(closure: { (Progress) in
                    print("Upload Progress: \(Progress.fractionCompleted)")
                })
                
                upload.responseJSON { response in
                    print(response.result)
                    
                    if response.result.value != nil{
                        var result : [String:AnyObject] = [String:AnyObject]()
                        result = response.result.value as! [String:AnyObject]
                        print("RESULT",result)
                        
                        let status : String = ResolutePOS.object_forKeyWithValidationForClass_String(dict: result, key: "Success")
                        if status == "True"
                        {
                            completionHandler(result as AnyObject)
                        }
                        else
                        {
                            completionHandler(result as AnyObject)
                            let message : String = ResolutePOS.object_forKeyWithValidationForClass_String(dict: result, key: "Message")
                            RSAlertUtils.displayAlertWithMessage(message)
                        }
                    }
                }
                break
            case .failure(let error):
                self.stopLoader()
                
                if error._code == NSURLErrorTimedOut {
                    //HANDLE TIMEOUT HERE
                }
                print("\n\nAuth request failed with error:\n \(error)")
                break
            }
        }
    }
    
    
    
    
    
    //MULTI PART DATA
    func postMultipartResponseWithDocument(_ url : String, params : [String : Any],headers: HTTPHeaders, imageFile : UIImage, completionHandler :@escaping (AnyObject) -> ())
    {
        startLoader()
        
        var strUrl : String = ""
        strUrl = CONSTANTS.BASE_URL.mainUrl + (url as String)
        
        let imageData = UIImageJPEGRepresentation(imageFile , 0.5)
        let pageURL = "\(strUrl)/dataIOS/add"
        
        print(strUrl)
        print(params)
        print(headers)
        
        let temp = Alamofire.SessionManager.default
        temp.session.configuration.timeoutIntervalForRequest = 15.151
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            for (key, value) in params {
                multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key)
            }
            multipartFormData.append(imageData!, withName: "upload_document", fileName: "img.png", mimeType: "image/jpeg")
        }, to:pageURL)
        { (result) in
            switch result {
            case .success(let upload, _, _):
                
                upload.uploadProgress(closure: { (Progress) in
                    print("Upload Progress: \(Progress.fractionCompleted)")
                })
                
                upload.responseJSON { response in
                    print(response.result)
                    
                    if response.result.value != nil{
                        var result : [String:AnyObject] = [String:AnyObject]()
                        result = response.result.value as! [String:AnyObject]
                        print("RESULT",result)
                        
                        let status : String = ResolutePOS.object_forKeyWithValidationForClass_String(dict: result, key: "Success")
                        if status == "True"
                        {
                            completionHandler(result as AnyObject)
                        }
                        else
                        {
                            completionHandler(result as AnyObject)
                            let message : String = ResolutePOS.object_forKeyWithValidationForClass_String(dict: result, key: "Message")
                            RSAlertUtils.displayAlertWithMessage(message)
                        }
                    }
                }
                break
            case .failure(let error):
                self.stopLoader()
                
                if error._code == NSURLErrorTimedOut {
                    //HANDLE TIMEOUT HERE
                }
                print("\n\nAuth request failed with error:\n \(error)")
                break
            }
        }
    }
   
    func startLoader() {
        let activityData = ActivityData()
        NVActivityIndicatorPresenter.sharedInstance.startAnimating(activityData)
    }
    
    func stopLoader() {
        NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
    }
}

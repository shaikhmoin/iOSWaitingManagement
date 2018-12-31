//
//  RSAlertUtils.swift
//  iOSWaitingManagement
//
//  Created by Akash on 12/27/18.
//  Copyright © 2018 Moin. All rights reserved.
//

import Foundation
import UIKit

class RSAlertUtils: NSObject {
    
    // MARK: - ALERT
    class func displayNoInternetMessage() {
        displayAlertWithMessage("Internet connectivity not available. Please check your internet connection and try again.", cancelButtonTitle: "Dismiss", buttons:[], completion: nil)
    }
    
    class func displayUnderDevelopmentAlert() {
        displayAlertWithMessage("Feature unavailable in this build.\n Please contact the development team and / or review the release notes. \n\n Thank you!", cancelButtonTitle: "Dismiss", buttons:[], completion: nil)
    }
    
    class func displayAlertWithMessage(_ message:String) -> Void {
        displayAlertWithMessage(message,cancelButtonTitle:  "Dismiss", buttons: [], completion: nil)
    }
    
    class func displayAlertWithMessage(_ message:String, cancelButtonTitle : String) -> Void {
        displayAlertWithMessage(message, cancelButtonTitle: cancelButtonTitle, buttons: [], completion: nil)
    }
    
    
    class func displayAlertWithMessage(_ message:String, cancelButtonTitle : String, buttons:[String], completion:((_ index:Int) -> Void)!) -> Void {
        
        let alertController = UIAlertController(title: APP_NAME, message: message, preferredStyle: .alert)
        
        for index in 0..<buttons.count    {
            
            let action = UIAlertAction(title: buttons[index], style: .default, handler: {
                (alert: UIAlertAction!) in
                if(completion != nil){
                    completion(index)
                }
            })
            
            action.setValue(COLOR_THEME_BLACK, forKey: "titleTextColor")
            alertController.addAction(action)
        }
        
        let cancelAction = UIAlertAction(title: cancelButtonTitle, style: .cancel, handler: nil)
        
        cancelAction.setValue(UIColor.darkGray, forKey: "titleTextColor")
        
        alertController.addAction(cancelAction)
        
        alertController.setValue(NSAttributedString(string: APP_NAME, attributes: [NSAttributedStringKey.font : UIFont.appFont_LatoRegular_WithSize(16), NSAttributedStringKey.foregroundColor : COLOR_THEME_BLACK]), forKey: "attributedTitle")
        
        alertController.setValue(NSAttributedString(string: message, attributes: [NSAttributedStringKey.font : UIFont.appFont_LatoRegular_WithSize(14), NSAttributedStringKey.foregroundColor : UIColor.darkGray]), forKey: "attributedMessage")
        
        APPDELEGATE.window?.rootViewController!.present(alertController, animated: true, completion:nil)
    }
    
    class func displayAlertWithTitleWithoutCancelButton(andMessage message:String, buttons:[String], completion:((_ index:Int) -> Void)!) -> Void {
        
        let alertController = UIAlertController(title: APP_NAME, message: message, preferredStyle: .alert)
        alertController.setValue(NSAttributedString(string: APP_NAME, attributes: [NSAttributedStringKey.font : UIFont.appFont_LatoRegular_WithSize(18), NSAttributedStringKey.foregroundColor : BLACK_COLOR]), forKey: "attributedTitle")
        
        alertController.setValue(NSAttributedString(string: message, attributes: [NSAttributedStringKey.font : UIFont.appFont_LatoRegular_WithSize(18), NSAttributedStringKey.foregroundColor : COLOR_TEXT_FIELD_SEPARATOR]), forKey: "attributedMessage")
        
        for index in 0..<buttons.count    {
            let action = UIAlertAction(title: buttons[index], style: .default, handler: {
                (alert: UIAlertAction!) in
                if(completion != nil){
                    completion(index)
                }
            })
            
            action.setValue(UIColor.darkGray, forKey: "titleTextColor")
            alertController.addAction(action)
        }
        
        UIApplication.shared.delegate!.window!?.rootViewController!.present(alertController, animated: true, completion:nil)
    }
    
    class func displayAlertWithTitle( andMessage message:String, buttons:[String], completion:((_ index:Int) -> Void)!) -> Void {
        
        let alertController = UIAlertController(title: APP_NAME, message: message, preferredStyle: .alert)
        alertController.setValue(NSAttributedString(string: APP_NAME, attributes: [NSAttributedStringKey.font : UIFont.appFont_LatoRegular_WithSize(18), NSAttributedStringKey.foregroundColor : BLACK_COLOR]), forKey: "attributedTitle")
        
        alertController.setValue(NSAttributedString(string: message, attributes: [NSAttributedStringKey.font : UIFont.appFont_LatoRegular_WithSize(18), NSAttributedStringKey.foregroundColor : COLOR_TEXT_FIELD_SEPARATOR]), forKey: "attributedMessage")
        
        for index in 0..<buttons.count    {
            let action = UIAlertAction(title: buttons[index], style: .default, handler: {
                (alert: UIAlertAction!) in
                if(completion != nil){
                    completion(index)
                }
            })
            
            action.setValue(UIColor.darkGray, forKey: "titleTextColor")
            alertController.addAction(action)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        cancelAction.setValue(UIColor.darkGray, forKey: "titleTextColor")
        alertController.addAction(cancelAction)
        
        UIApplication.shared.delegate!.window!?.rootViewController!.present(alertController, animated: true, completion:nil)
    }
    
    class func displayActionSheetWithTitle(_ title:String, andMessage message:String, buttons:[String], completion:((_ index:Int) -> Void)!) -> Void {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        alertController.setValue(NSAttributedString(string: title, attributes: [NSAttributedStringKey.font : UIFont.appFont_LatoRegular_WithSize(18), NSAttributedStringKey.foregroundColor : COLOR_THEME_ORANGE]), forKey: "attributedTitle")
        
        alertController.setValue(NSAttributedString(string: message, attributes: [NSAttributedStringKey.font : UIFont.appFont_LatoRegular_WithSize(18), NSAttributedStringKey.foregroundColor : COLOR_TEXT_FIELD_SEPARATOR]), forKey: "attributedMessage")
        
        for index in 0..<buttons.count    {
            
            let action = UIAlertAction(title: buttons[index], style: .default, handler: {
                (alert: UIAlertAction!) in
                if(completion != nil){
                    completion(index)
                }
            })
            
            action.setValue(UIColor.darkGray, forKey: "titleTextColor")
            alertController.addAction(action)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        cancelAction.setValue(UIColor.darkGray, forKey: "titleTextColor")
        alertController.addAction(cancelAction)
        
        UIApplication.shared.delegate!.window!?.rootViewController!.present(alertController, animated: true, completion:nil)
    }
}

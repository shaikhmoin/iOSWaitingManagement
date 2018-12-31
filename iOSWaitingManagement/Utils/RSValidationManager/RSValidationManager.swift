//
//  RSValidationManager.swift
//  iOSWaitingManagement
//
//  Created by Akash on 12/27/18.
//  Copyright © 2018 Moin. All rights reserved.
//

import UIKit
import Foundation

//MARK:- CONSTANTS
let MINIMUM_CHAR_NAME = 3
let MAXIMUM_CHAR_NAME = 30

let MINIMUM_CHAR_EMAIL = 3
let MAXIMUM_CHAR_EMAIL = 60

let MINIMUM_CHAR_PASSWORD = 6
let MAXIMUM_CHAR_PASSWORD = 16

let MINIMUM_CHAR_PHONE_NUMBER = 10
let MAXIMUM_CHAR_PHONE_NUMBER = 20

let MINIMUM_CHAR_ADDRESS = 3
let MAXIMUM_CHAR_ADDRESS = 500

let MAXIMUM_CHAR_ZIPCODE = 6

let MAXIMUM_CHAR_PRODUCT_REVIEW = 250
let MAXIMUM_CHAR_CREDIT_CARD_NUMBER = 16

let MINIMUM_CHAR_AGE = 1
let MAXIMUM_CHAR_AGE = 2

let MINIMUM_CHAR_NORMAL = 1
let MAXIMUM_CHAR_NORMAL = 250

enum RSValidationRule: Int {
    case
    emptyCheck,
    minMaxLength,
    fixedLength,
    emailCheck,
    upperCase,
    lowerCase,
    specialCharacter,
    digitCheck,
    none
}
class RSValidationManager: NSObject {
    
    static let sharedManager : RSValidationManager = {
        let instance = RSValidationManager()
        return instance
    }()
    
    //MARK:- VALIDATION CHECK
    func validateTextField(_ txtField:UITextField, forRule rule:RSValidationRule, withMinimumChar minChar:Int, andMaximumChar maxChar:Int) -> (isValid:Bool, errMessage:String, txtFieldWhichFailedValidation:UITextField)? {
        
        switch rule {
            
        case .emptyCheck:
            return (txtField.text?.characters.count == 0) ? (false, "Enter \(txtField.placeholder!.lowercased())!",txtField) : nil
            
        case .minMaxLength:
            return (txtField.text!.characters.count < minChar || txtField.text!.characters.count > maxChar) ? (false,"\(txtField.placeholder!) should be of \(minChar) to \(maxChar) characters.",txtField) : nil
            
        case .fixedLength:
            return (txtField.text!.characters.count != minChar) ? (false,"\(txtField.placeholder!) should be of \(minChar) characters.",txtField) : nil
            
        case .emailCheck:
            return (!(txtField.text?.isValidEmail())!) ? (false,"Please enter valid user name.",txtField) : nil
            
        case .upperCase:
            return ((txtField.text! as NSString).rangeOfCharacter(from: CharacterSet.uppercaseLetters).location == NSNotFound) ? (false,"\(txtField.placeholder!) should contain atleast one uppercase letter.",txtField) : nil
            
        case .lowerCase:
            return ((txtField.text! as NSString).rangeOfCharacter(from: CharacterSet.lowercaseLetters).location == NSNotFound) ? (false,"\(txtField.placeholder!) should contain atleast one lowercase letter.",txtField) : nil
            
        case .specialCharacter:
            let symbolCharacterSet = NSMutableCharacterSet.symbol()
            symbolCharacterSet.formUnion(with: CharacterSet.punctuationCharacters)
            return ((txtField.text! as NSString).rangeOfCharacter(from: symbolCharacterSet as CharacterSet).location == NSNotFound) ? (false,"\(txtField.placeholder!) should contain atleast one special letter.",txtField) : nil
            
        case .digitCheck:
            return ((txtField.text! as NSString).rangeOfCharacter(from: CharacterSet(charactersIn: "0123456789") as CharacterSet).location == NSNotFound) ? (false,"\(txtField.placeholder!) should contain atleast one digit letter.",txtField) : nil
            
        case .none:
            return nil
        }
    }
    
    
    func validateTextField(_ txtField:UITextField, forRules rules:[RSValidationRule]) -> (isValid:Bool, errMessage:String, txtFieldWhichFailedValidation:UITextField)? {
        
        return validateTextField(txtField, forRules: rules, withMinimumChar: 0, andMaximumChar: 0)
        
    }
    
    func validateTextField(_ txtField:UITextField, forRules rules:[RSValidationRule], withMinimumChar minChar:Int, andMaximumChar maxChar:Int) -> (isValid:Bool, errMessage:String, txtFieldWhichFailedValidation:UITextField)? {
        
        var strMessage:String = ""
        for eachRule in rules {
            if let result = validateTextField(txtField, forRule: eachRule, withMinimumChar: minChar, andMaximumChar: maxChar)   {
                if(eachRule == RSValidationRule.emptyCheck){
                    return result
                }else{
                    strMessage += "\(strMessage.characters.count == 0 ? "" : "\n\n") \(result.errMessage)"
                }
            }
        }
        return strMessage.characters.count > 0 ? (false,strMessage,txtField) : nil
    }
}

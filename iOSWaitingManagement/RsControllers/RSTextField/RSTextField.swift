//
//  RSTextField.swift
//  iOSWaitingManagement
//
//  Created by Akash on 12/27/18.
//  Copyright © 2018 Moin. All rights reserved.
//

import Foundation
import UIKit

class RSTextField: UITextField, UITextFieldDelegate,UIPickerViewDataSource,UIPickerViewDelegate {
    
    let viewSeparator : UIView = UIView()
    var minLength : Int = 0
    var maxLength : Int = 256
    var strPlaceHolder : String = ""
    
    var didSelectFloor : ((_ selectedFloor : Int) -> Void)!
    
    var textFieldType : RSTextFieldType = .Normal
    var selectedDate  : NSDate!
    var getPicker : UIPickerView = UIPickerView()
    let requestFromdatePicker = UIDatePicker()
    let requestTodatePicker = UIDatePicker()
    
    var TextFieldShouldReturnHandler:((_ textField: UITextField) -> Void)?
    var aryFloorList : [AnyObject] = [AnyObject]()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.autocorrectionType = UITextAutocorrectionType.no
    }
    
    override func awakeFromNib() {
        self.strPlaceHolder = self.placeholder!
        self.delegate = self
    }
    
    //DISABLE PASTE
    override public func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if action == #selector(copy(_:)) || action == #selector(paste(_:))
        {
            return false
        }
        return false
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string == "" {
            return true
        }
        
        if textFieldType == .Name {
            if (textField.text?.characters.count)! >= 20 {
                return false
            }
            else
            {
                return true
            }
        }
        
        if textFieldType == .Email {
            if (textField.text?.characters.count)! >= 30 {
                return false
            }
            else
            {
                return true
            }
        }
        
        if textFieldType == .Password {
            if (textField.text?.characters.count)! >= 30 {
                return false
            }
            else
            {
                return true
            }
        }
        
        if textFieldType == .Name {
            let aSet = NSCharacterSet(charactersIn:"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz").inverted
            let compSepByCharInSet = string.components(separatedBy: aSet)
            let numberFiltered = compSepByCharInSet.joined(separator: "")
            return string == numberFiltered
        }
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textFieldType == .FromDate
        {
            addToolBar()
            requestFromdatePicker.datePickerMode = .date
            textField.inputView = requestFromdatePicker
            requestFromdatePicker.maximumDate = Date()
            
            requestFromdatePicker.addTarget(self, action: #selector(datePickerFromDateClicked(sender:)), for: .valueChanged)
    
        } else if textFieldType == .Floor {
            if aryFloorList.count == 0 {
                RSAlertUtils.displayAlertWithMessage("You have no any floor list!")
                self.inputView = UIView()
            }else {
                addToolBar()
                self.inputView = getPicker
            }
        }
        
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func setTextFieldType(tFieldType : RSTextFieldType)
    {
        textFieldType = tFieldType
        self.keyboardType = .asciiCapable
        switch textFieldType {
        case .Normal:
            minLength = MINIMUM_CHAR_NORMAL
            maxLength = MAXIMUM_CHAR_NORMAL
            break
        case .Name:
            minLength = MINIMUM_CHAR_NAME
            maxLength = MAXIMUM_CHAR_NAME
            break
            
        case .Email:
            minLength = MINIMUM_CHAR_EMAIL
            maxLength = MAXIMUM_CHAR_EMAIL
            self.keyboardType = .emailAddress
            break
            
        case .Password:
            minLength = MINIMUM_CHAR_PASSWORD
            maxLength = MAXIMUM_CHAR_PASSWORD
            break

        case .FromDate:
            FromDatePicker()
            break

        case .ToDate:
            ToDatePicker()
            break
            
        case .Floor:
            FloorList()
            break
            
        default:
            break
        }
    }
    
    func addToolBar(){
        let toolBar = UIToolbar()
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor.black
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: #selector(RSTextField.donePressed))
        
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.plain, target: self, action: #selector(RSTextField.cancelPressed))
        
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        toolBar.sizeToFit()
        
        self.inputAccessoryView = toolBar
    }
    
    //MARK:- PICKER SELECTED VALUE CLICKED
    @objc func datePickerFromDateClicked(sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        self.text = dateFormatter.string(from: sender.date)
    }
    
    @objc func datePickerToDateClicked(sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        self.text = dateFormatter.string(from: sender.date)
    }
    
    //MARK:- DONE
    @objc func donePressed(){
        
        let row: Int = getPicker.selectedRow(inComponent: 0)
        if getPicker.tag == 1 {
            if aryFloorList.count > 0 {
                let dict : [String : AnyObject] = aryFloorList[row] as! [String : AnyObject]
                print(dict)
                APPDELEGATE.strSelectedFloorID = (dict["FloorID"] as? Int)!
                self.text = (dict["FloorName"] as? String)!
                
                if APPDELEGATE.strSelectedFloorID != 0 {
                    if self.didSelectFloor != nil {
                        self.didSelectFloor(APPDELEGATE.strSelectedFloorID)
                    }
                }
            } 
        }
        self.endEditing(true)
    }
    
    //MARK:- CANCEL
    @objc func cancelPressed(){
        self.resignFirstResponder()
    }
    
    //MARK:- Picker Methods
    func FromDatePicker(){
        //getPicker.tag = 1
        addToolBar()
        getPicker.delegate = self
        getPicker.dataSource = self
        self.inputView = getPicker
        self.layer.borderColor = UIColor.lightGray.cgColor
        self.layer.borderWidth = 0.5
    }

    func ToDatePicker(){
        //getPicker.tag = 2
        addToolBar()
        getPicker.delegate = self
        getPicker.dataSource = self
        self.inputView = getPicker
        self.layer.borderColor = UIColor.lightGray.cgColor
        self.layer.borderWidth = 0.5
    }
    
    func FloorList(){
        getPicker.delegate = self
        getPicker.tag = 1
        addToolBar()
        self.inputView = getPicker
    }
    
    func setUpFloorList(data : [AnyObject]){
        aryFloorList = data as [AnyObject]
        print(aryFloorList)
        
        if aryFloorList.count > 0 {
            let dict : [String : AnyObject] = aryFloorList[0] as! [String : AnyObject]
            APPDELEGATE.strSelectedFloorID = (dict["FloorID"] as? Int)!
            self.text = dict["FloorName"] as? String
            
            if APPDELEGATE.strSelectedFloorID != 0 {
                if self.didSelectFloor != nil {
                    self.didSelectFloor(APPDELEGATE.strSelectedFloorID)
                }
            }
        }
    }
    
    //MARK: UIPickerViewDelegate
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if getPicker.tag == 1 {
            return aryFloorList.count
        }
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if getPicker.tag == 1
        {
            let dict : [String : AnyObject] = aryFloorList[row] as! [String : AnyObject]
            return dict["FloorName"] as? String
        }
        return ""
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if getPicker.tag == 1
        {
            let dict : [String : AnyObject] = aryFloorList[row] as! [String : AnyObject]
            self.text = dict["FloorName"] as? String
        }
    }
}

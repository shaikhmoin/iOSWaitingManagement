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
    var didSelectLocation : ((_ selectedLocation : Int) -> Void)!
    var didSelectCounter : ((_ selectedCounter : Int) -> Void)!
    var didSelectTablet : ((_ selectedTablet : Int) -> Void)!
    
    var textFieldType : RSTextFieldType = .Normal
    var selectedDate  : NSDate!
    var getPicker : UIPickerView = UIPickerView()
    let requestFromdatePicker = UIDatePicker()
    let requestTodatePicker = UIDatePicker()
    
    var TextFieldShouldReturnHandler:((_ textField: UITextField) -> Void)?
    var aryFloorList : [AnyObject] = [AnyObject]()
    var aryLocationList : [AnyObject] = [AnyObject]()
    var aryCounterList : [AnyObject] = [AnyObject]()
    var aryTabletList : [AnyObject] = [AnyObject]()
    
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
     
        } else if textFieldType == .Location {
            if aryLocationList.count == 0 {
                RSAlertUtils.displayAlertWithMessage("You have no any location list!")
                self.inputView = UIView()
            }else {
                addToolBar()
                self.inputView = getPicker
            }
     
        } else if textFieldType == .Counter {
            if aryCounterList.count == 0 {
                RSAlertUtils.displayAlertWithMessage("You have no any counter list!")
                self.inputView = UIView()
            }else {
                addToolBar()
                self.inputView = getPicker
            }
       
        } else if textFieldType == .Tablet {
            if aryTabletList.count == 0 {
                RSAlertUtils.displayAlertWithMessage("You have no any tablet list!")
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
            
        case .Location:
            LocationList()
            break
            
        case .Counter:
            CounterList()
            break
    
        case .Tablet:
            TabletList()
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
            
        } else if getPicker.tag == 2 {
            if aryLocationList.count > 0 {
                let dict : [String : AnyObject] = aryLocationList[row] as! [String : AnyObject]
                print(dict)
                APPDELEGATE.strSelectedLocationID = (dict["LocationID"] as? Int)!
                self.text = (dict["LocationName"] as? String)!
                
                if APPDELEGATE.strSelectedLocationID != 0 {
                    if self.didSelectLocation != nil {
                        self.didSelectLocation(APPDELEGATE.strSelectedLocationID)
                    }
                }
            }
   
        } else if getPicker.tag == 3 {
            if aryCounterList.count > 0 {
                let dict : [String : AnyObject] = aryCounterList[row] as! [String : AnyObject]
                print(dict)
                APPDELEGATE.strSelectedCounterID = (dict["CounterID"] as? Int)!
                self.text = (dict["CounterName"] as? String)!
                
                if APPDELEGATE.strSelectedCounterID != 0 {
                    if self.didSelectCounter != nil {
                        //self.didSelectCounter(APPDELEGATE.strSelectedCounterID)
                    }
                }
            }
     
        } else if getPicker.tag == 4 {
            if aryTabletList.count > 0 {
                let dict : [String : AnyObject] = aryTabletList[row] as! [String : AnyObject]
                print(dict)
                APPDELEGATE.dictSelectedTab = dict
                APPDELEGATE.strSelectedTabletID = (dict["TabID"] as? Int)!
                self.text = (dict["TabName"] as? String)!
                
                if APPDELEGATE.strSelectedTabletID != 0 {
                    if self.didSelectTablet != nil {
                        self.didSelectTablet(APPDELEGATE.strSelectedTabletID)
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
    
    func LocationList(){
        getPicker.delegate = self
        getPicker.tag = 2
        addToolBar()
        self.inputView = getPicker
    }
    
    func CounterList(){
        getPicker.delegate = self
        getPicker.tag = 3
        addToolBar()
        self.inputView = getPicker
    }
    
    func TabletList(){
        getPicker.delegate = self
        getPicker.tag = 4
        addToolBar()
        self.inputView = getPicker
    }
    
    //Setup Floor Data
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
    
    //Setup Location Data
    func setUpLocationList(data : [AnyObject]){
        aryLocationList = data as [AnyObject]
        print(aryLocationList)
        
        if aryLocationList.count > 0 {
            let dict : [String : AnyObject] = aryLocationList[0] as! [String : AnyObject]
            //APPDELEGATE.strSelectedLocationID = (dict["LocationID"] as? Int)!
//            self.text = dict["FloorName"] as? String
            
            if APPDELEGATE.strSelectedLocationID != 0 {
                if self.didSelectLocation != nil {
                    //self.didSelectLocation(APPDELEGATE.strSelectedLocationID)
                }
            }
        }
    }
    
    //Setup Counter Data
    func setUpCounterList(data : [AnyObject]){
        aryCounterList = data as [AnyObject]
        print(aryCounterList)
        
        if aryCounterList.count > 0 {
            let dict : [String : AnyObject] = aryCounterList[0] as! [String : AnyObject]
            APPDELEGATE.strSelectedCounterID = (dict["CounterID"] as? Int)!
            self.text = dict["CounterName"] as? String

            if APPDELEGATE.strSelectedCounterID != 0 {
                if self.didSelectCounter != nil {
                    //self.didSelectCounter(APPDELEGATE.strSelectedCounterID)
                }
            }
        }
    }
    
    //Setup Tablet Data
    func setUpTabletList(data : [AnyObject]){
        aryTabletList = data as [AnyObject]
        print(aryTabletList)
        
        if aryTabletList.count > 0 {
            let dict : [String : AnyObject] = aryTabletList[0] as! [String : AnyObject]
            //APPDELEGATE.strSelectedTabletID = (dict["TabID"] as? Int)!
            //self.text = dict["TabName"] as? String
            
            if APPDELEGATE.strSelectedTabletID != 0 {
                if self.didSelectTablet != nil {
                    //self.didSelectTablet(APPDELEGATE.strSelectedTabletID)
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
       
        } else if getPicker.tag == 2 {
            return aryLocationList.count
      
        }  else if getPicker.tag == 3 {
            return aryCounterList.count
       
        }  else if getPicker.tag == 4 {
            return aryTabletList.count
        }
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if getPicker.tag == 1
        {
            let dict : [String : AnyObject] = aryFloorList[row] as! [String : AnyObject]
            return dict["FloorName"] as? String
      
        } else if getPicker.tag == 2 {
            let dict : [String : AnyObject] = aryLocationList[row] as! [String : AnyObject]
            return dict["LocationName"] as? String
     
        }  else if getPicker.tag == 3 {
            let dict : [String : AnyObject] = aryCounterList[row] as! [String : AnyObject]
            return dict["CounterName"] as? String
      
        }  else if getPicker.tag == 4 {
            let dict : [String : AnyObject] = aryTabletList[row] as! [String : AnyObject]
            return dict["TabName"] as? String
        }
        return ""
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if getPicker.tag == 1
        {
            let dict : [String : AnyObject] = aryFloorList[row] as! [String : AnyObject]
            self.text = dict["FloorName"] as? String
    
        } else if getPicker.tag == 2 {
            let dict : [String : AnyObject] = aryLocationList[row] as! [String : AnyObject]
            self.text = dict["LocationName"] as? String
      
        }  else if getPicker.tag == 3 {
            let dict : [String : AnyObject] = aryCounterList[row] as! [String : AnyObject]
            self.text = dict["CounterName"] as? String
      
        }  else if getPicker.tag == 4 {
            let dict : [String : AnyObject] = aryTabletList[row] as! [String : AnyObject]
            self.text = dict["TabName"] as? String
        }
    }
}

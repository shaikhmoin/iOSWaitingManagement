//
//  RSExtention.swift
//  iOSWaitingManagement
//
//  Created by Akash on 12/27/18.
//  Copyright © 2018 Moin. All rights reserved.
//

import Foundation
import UIKit

extension UITextView: UITextViewDelegate {
    override open var bounds: CGRect {
        didSet {
            self.resizePlaceholder()
        }
    }
    
    public var placeholder: String? {
        get {
            var placeholderText: String?
            
            if let placeholderLbl = self.viewWithTag(50) as? UILabel {
                placeholderText = placeholderLbl.text
            }
            return placeholderText
        }
        set {
            if let placeholderLbl = self.viewWithTag(50) as! UILabel? {
                placeholderLbl.text = newValue
                placeholderLbl.sizeToFit()
            } else {
                self.addPlaceholder(newValue!)
            }
        }
    }
    
    public func textViewDidChange(_ textView: UITextView) {
        if let placeholderLbl = self.viewWithTag(50) as? UILabel {
            placeholderLbl.isHidden = self.text.characters.count > 0
        }
    }
    
    private func resizePlaceholder() {
        if let placeholderLbl = self.viewWithTag(50) as! UILabel? {
            let x = self.textContainer.lineFragmentPadding
            let y = self.textContainerInset.top - 2
            let width = self.frame.width - (x * 2)
            let height = placeholderLbl.frame.height
            
            placeholderLbl.frame = CGRect(x: x, y: y, width: width, height: height)
        }
    }
    
    private func addPlaceholder(_ placeholderText: String) {
        let placeholderLbl = UILabel()
        
        placeholderLbl.text = placeholderText
        placeholderLbl.sizeToFit()
        
        placeholderLbl.font = self.font
        placeholderLbl.textColor = UIColor.lightGray
        placeholderLbl.tag = 50
        
        placeholderLbl.isHidden = self.text.characters.count > 0
        
        self.addSubview(placeholderLbl)
        self.resizePlaceholder()
        self.delegate = self
    }
}

extension CGFloat
{
    func proportionalFontSize() -> CGFloat {
        var sizeToCheckAgainst = self
        if(IS_IPAD_DEVICE())    {
            sizeToCheckAgainst += 5
        }
        else {
            if(IS_IPHONE_6P_OR_6SP()) {
                sizeToCheckAgainst += 1
            }
            else if(IS_IPHONE_6_OR_6S()) {
                sizeToCheckAgainst += 1
            }
            else if(IS_IPHONE_5_OR_5S()) {
                sizeToCheckAgainst -= 0
            }
            else if(IS_IPHONE_4_OR_4S()) {
                sizeToCheckAgainst -= 3
            }
        }
        return sizeToCheckAgainst
    }
}

extension Data {
    var html2AttributedString: NSAttributedString? {
        do {
            return try NSAttributedString(data: self, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            print("error:", error)
            return  nil
        }
    }
    var html2String: String {
        return html2AttributedString?.string ?? ""
    }
}

extension String {
    
    var utfData: Data? {
        return self.data(using: .utf8)
    }
    
    var htmlAttributedString: NSAttributedString? {
        guard let data = self.utfData else {
            return nil
        }
        do {
            return try NSAttributedString(data: data,
                                          options: [
                                            NSAttributedString.DocumentReadingOptionKey.documentType : NSAttributedString.DocumentType.html,
                                            NSAttributedString.DocumentReadingOptionKey.characterEncoding: String.Encoding.utf8.rawValue
                ], documentAttributes: nil)
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
    var html2AttributedString: NSAttributedString? {
        return Data(utf8).html2AttributedString
    }
    
    var html2String: String {
        return html2AttributedString?.string ?? ""
    }
    
    func HtmlToString( htmlstring : String  ) -> String {
        
        var htmlstr:String = htmlstring
        
        let attrStr = try! NSMutableAttributedString(
            data: htmlstr.data(using: String.Encoding.unicode, allowLossyConversion: true)!,
            options: [.documentType: NSAttributedString.DocumentType.html,
                      .characterEncoding: String.Encoding.utf8.rawValue],
            documentAttributes: nil)
        
        htmlstr = attrStr.string
        
        htmlstr = htmlstr.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
        
        return htmlstr
    }
    
    func heightWithWidthAndFont(_ width: CGFloat, font: UIFont) -> CGFloat {
        
        let constraintRect = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font: font], context: nil)
        return boundingBox.height
    }
    
    
    func isValidEmail() -> Bool    {
        return ( (isValidEmail(self as String))  && (isValidEmail_NEW(self as String)) )
    }
    
    func isValidEmail(_ stringToCheckForEmail:String) -> Bool {
        let emailRegex = "[A-Z0-9a-z]+([._%+-]{1}[A-Z0-9a-z]+)*@[A-Z0-9a-z]+([.-]{1}[A-Z0-9a-z]+)*(\\.[A-Za-z]{2,4}){0,1}"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: stringToCheckForEmail)
    }
    
    func isValidEmail_NEW(_ stringToCheckForEmail:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: stringToCheckForEmail)
    }
    
    func object_forKeyWithValidationForClass_String(dict: [String: AnyObject], key: String) -> String
    {
        var strValue: String = ""
        if (dict[key] as? String) != nil  {
            strValue = dict[key] as! String
        } else {
            strValue = ""
        }
        return strValue
    }
}


extension NSString
{
    func trim() -> String    {
        return self.trimmingCharacters(in: CharacterSet.whitespaces)
    }
}

extension NSLayoutConstraint {
    
    func setMultiplier(_ multiplier:CGFloat) -> NSLayoutConstraint {
        
        let newConstraint = NSLayoutConstraint(
            item: firstItem ?? "",
            attribute: firstAttribute,
            relatedBy: relation,
            toItem: secondItem,
            attribute: secondAttribute,
            multiplier: multiplier,
            constant: constant)
        
        newConstraint.priority = priority
        newConstraint.shouldBeArchived = self.shouldBeArchived
        newConstraint.identifier = self.identifier
        newConstraint.isActive = true
        
        NSLayoutConstraint.deactivate([self])
        NSLayoutConstraint.activate([newConstraint])
        return newConstraint
    }
}

extension UILabel {
    
    func setLineHeight(_ lineHeight: CGFloat) {
        self.setLineHeight(lineHeight, withAlignment: .center)
        
    }
    
    func applyLableroundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
    
    func setLineHeight(_ lineHeight: CGFloat, withAlignment alignment:NSTextAlignment) {
        let text = self.text
        if let text = text {
            let attributeString = NSMutableAttributedString(string: text)
            
            let style = NSMutableParagraphStyle()
            style.lineSpacing = lineHeight
            style.alignment = alignment
            attributeString.addAttribute(NSAttributedStringKey.paragraphStyle, value: style, range: NSMakeRange(0, text.characters.count))
            self.attributedText = attributeString
        }
    }
}

extension UITextView {
    func setBottomShadow() {
        self.layer.backgroundColor = UIColor.white.cgColor
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.lightGray.cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 0.0
    }
}

extension UITextField {
    func addLeftImage(imageName: String) {
        
        let textLeftView: UIView = UIView(frame: CGRect(x: 10, y: 0, width: 20 , height:25))
        textLeftView.backgroundColor = UIColor.clear
        //EFF0F2
        self.leftViewMode = UITextFieldViewMode.always
        let imageView = UIImageView(frame: CGRect(x: 4, y: 2, width: 18 , height: 18))
        let image = UIImage(named: imageName)
        imageView.image = image
        textLeftView.addSubview(imageView)
        self.leftView = textLeftView
    }
    
    func addRightImage(imageName: String) {
        
        let textRightview: UIView = UIView(frame: CGRect(x: -10, y: 0, width: 18 , height:25))
        textRightview.backgroundColor = UIColor(hexString: "#FFFFFF")
        self.rightViewMode = UITextFieldViewMode.always
        let imageView = UIImageView(frame: CGRect(x: 0, y: 2, width: 18 , height: 18))
        let image = UIImage(named: imageName)
        imageView.image = image
        textRightview.addSubview(imageView)
        self.rightView = textRightview
    }
    func setBottomShadow() {
        self.borderStyle = .none
        self.layer.backgroundColor = UIColor.white.cgColor
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.lightGray.cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 0.0
    }
    
    func setLeftPaddingPoints(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    func setRightPaddingPoints(_ amount:CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
    
    @IBInspectable var placeHolderColor: UIColor? {
        get {
            return self.placeHolderColor
        }
        set {
            self.attributedPlaceholder = NSAttributedString(string:self.placeholder != nil ? self.placeholder! : "", attributes:[NSAttributedStringKey.foregroundColor: newValue!])
        }
    }
}

extension UIButton {
    func Shadow()  {
        self.layer.shadowRadius = 3.0
        self.layer.shadowColor = UIColor(red: CGFloat(64.0/255.0), green: CGFloat(41.0/255.0), blue: CGFloat(26.0/255.0), alpha: CGFloat(1.0)).cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 8.0)
        self.layer.shadowOpacity = 0.20
        self.layer.masksToBounds = false
    }
    func BottomShadow()  {
        self.layer.shadowRadius = 3.0
        self.layer.shadowColor = UIColor(hexString: "#462D21").cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 8.0)
        self.layer.shadowOpacity = 0.20
        self.layer.masksToBounds = false
    }
    func buttonHelper()  {
        self.layer.cornerRadius = 13
        self.titleLabel?.font = UIFont.boldSystemFont(ofSize: 12)
        self.backgroundColor = UIColor.red
    }
    func dashboardButtonHelper()  {
        self.layer.cornerRadius = 15
        self.titleLabel?.font = UIFont.boldSystemFont(ofSize: 12)
        self.backgroundColor = UIColor.red
    }
    
    func roundedButton(){
        let maskPAth1 = UIBezierPath(roundedRect: self.bounds,
                                     byRoundingCorners: [.topLeft , .topRight],
                                     cornerRadii:CGSize(width:10.0, height:10.0))
        let maskLayer1 = CAShapeLayer()
        maskLayer1.frame = self.bounds
        maskLayer1.path = maskPAth1.cgPath
        self.layer.mask = maskLayer1
    }
    
    func roundedButtonRollback(){
        let maskPAth1 = UIBezierPath(roundedRect: self.bounds,
                                     byRoundingCorners: [.topLeft , .topRight],
                                     cornerRadii:CGSize(width:0.0, height:0.0))
        let maskLayer1 = CAShapeLayer()
        maskLayer1.frame = self.bounds
        maskLayer1.path = maskPAth1.cgPath
        self.layer.mask = maskLayer1
    }
}

extension CALayer {
    
    func ViewroundCorners(corners: UIRectCorner, radius: CGFloat) {
        let maskPath = UIBezierPath(roundedRect: bounds,
                                    byRoundingCorners: corners,
                                    cornerRadii: CGSize(width: radius, height: radius))
        
        let shape = CAShapeLayer()
        shape.path = maskPath.cgPath
        mask = shape
    }
    
    func addBorder(edge: UIRectEdge, color: UIColor, thickness: CGFloat) {
        
        let border = CALayer()
        
        switch edge {
        case UIRectEdge.top:
            border.frame = CGRect.init(x: 0, y: 0, width: frame.width, height: thickness)
            break
        case UIRectEdge.bottom:
            border.frame = CGRect.init(x: 0, y: frame.height - thickness, width: frame.width, height: thickness)
            break
        case UIRectEdge.left:
            border.frame = CGRect.init(x: 0, y: 0, width: thickness, height: frame.height)
            break
        case UIRectEdge.right:
            border.frame = CGRect.init(x: frame.width - thickness, y: 0, width: thickness, height: frame.height)
            break
        default:
            break
        }
        
        border.backgroundColor = color.cgColor;
        self.addSublayer(border)
    }
}

extension UIFont {
    
    // LATO HEAVY
    class func appFont_LatoHeavy_WithSize(_ fontSize : CGFloat) -> UIFont {
        return UIFont(name: "Lato-Heavy", size: fontSize.proportionalFontSize())!
    }
    
    // LATO BLACK
    class func appFont_LatoBlack_WithSize(_ fontSize : CGFloat) -> UIFont {
        return UIFont(name: "Lato-Black", size: fontSize.proportionalFontSize())!
    }
    
    // LATO BOLD
    class func appFont_LatoBold_WithSize(_ fontSize : CGFloat) -> UIFont {
        return UIFont(name: "Lato-Bold", size: fontSize.proportionalFontSize())!
    }
    
    // LATO SEMIBOLD
    class func appFont_LatoSemiBold_WithSize(_ fontSize : CGFloat) -> UIFont {
        return UIFont(name: "Lato-Semibold", size: fontSize.proportionalFontSize())!
    }
    
    // LATO REGULAR
    class func appFont_LatoRegular_WithSize(_ fontSize : CGFloat) -> UIFont {
        return UIFont(name: "Lato-Regular", size: fontSize.proportionalFontSize())!
    }
    
    // LATO MEDIUM
    class func appFont_LatoMedium_WithSize(_ fontSize : CGFloat) -> UIFont {
        return UIFont(name: "Lato-Medium", size: fontSize.proportionalFontSize())!
    }
    
    // LATO IATLIC
    class func appFont_LatoItalic_WithSize(_ fontSize : CGFloat) -> UIFont {
        return UIFont(name: "Lato-Italic", size: fontSize.proportionalFontSize())!
    }
    
    // LATO LIGHT
    class func appFont_LatoLight_WithSize(_ fontSize : CGFloat) -> UIFont {
        return UIFont(name: "Lato-Light", size: fontSize.proportionalFontSize())!
    }
    
    // LATO LIGHT ITALIC
    class func appFont_LatoLightItalic_WithSize(_ fontSize : CGFloat) -> UIFont {
        return UIFont(name: "Lato-LightItalic", size: fontSize.proportionalFontSize())!
    }
    
    // LATO THIN
    class func appFont_LatoThin_WithSize(_ fontSize : CGFloat) -> UIFont {
        return UIFont(name: "Lato-Thin", size: fontSize.proportionalFontSize())!
    }
    
    // LATO HAIRLINE
    class func appFont_LatoHairline_WithSize(_ fontSize : CGFloat) -> UIFont {
        return UIFont(name: "Lato-Hairline", size: fontSize.proportionalFontSize())!
    }
    
    // LATO HAIRLINE ITALIC
    class func appFont_LatoHairlineItalic_WithSize(_ fontSize : CGFloat) -> UIFont {
        return UIFont(name: "Lato-HairlineItalic", size: fontSize.proportionalFontSize())!
    }
}

extension UIColor
{
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(netHex:Int) {
        self.init(red:(netHex >> 16) & 0xff, green:(netHex >> 8) & 0xff, blue:netHex & 0xff)
    }
    
    convenience init(hexString:String) {
        let hexString:String = hexString.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
        let scanner            = Scanner(string: hexString as String)
        
        if (hexString.hasPrefix("#")) {
            scanner.scanLocation = 1
        }
        
        var color:UInt32 = 0
        scanner.scanHexInt32(&color)
        
        let mask = 0x000000FF
        let r = Int(color >> 16) & mask
        let g = Int(color >> 8) & mask
        let b = Int(color) & mask
        
        let red   = CGFloat(r) / 255.0
        let green = CGFloat(g) / 255.0
        let blue  = CGFloat(b) / 255.0
        
        self.init(red:red, green:green, blue:blue, alpha:1)
    }
    
    func toHexString() -> String {
        var r:CGFloat = 0
        var g:CGFloat = 0
        var b:CGFloat = 0
        var a:CGFloat = 0
        
        getRed(&r, green: &g, blue: &b, alpha: &a)
        
        let rgb:Int = (Int)(r*255)<<16 | (Int)(g*255)<<8 | (Int)(b*255)<<0
        
        return NSString(format:"#%06x", rgb) as String
    }
    
    //IOS POS
    class func APP_ACCENT_COLOR()->UIColor
    {
        return UIColor(red: 9.0/255.0, green: 26.0/255.0, blue: 89.0/255.0, alpha: 1.0)
    }
    class func APP_LIGHTBROWN_COLOR()->UIColor
    {
        return UIColor(red: 193.0/255.0, green: 166.0/255.0, blue: 150.0/255.0, alpha: 1.0)
    }
    class func APP_BUTTON_TITLE_COLOR()->UIColor
    {
        return UIColor(red: 215.0/255.0, green: 198.0/255.0, blue: 188.0/255.0, alpha: 1.0)
    }
    
    class func APP_YELLOW_COLOR()->UIColor
    {
        return UIColor(red: 224.0/255.0, green: 162.0/255.0, blue: 42.0/255.0, alpha: 1.0)
    }
    
    class func APP_BROWN_COLOR_WHITE()->UIColor
    {
        return UIColor(red: 86.0/255.0, green: 55.0/255.0, blue: 38.0/255.0, alpha: 1.0)
    }
}

extension UIImageView
{
    func applyImageViewroundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
}

extension UIView
{
    public var borderColor: UIColor? {
        get {
            guard let color = layer.borderColor else {
                return nil
            }
            return UIColor(cgColor: color)
        }
        set {
            guard let color = newValue else {
                layer.borderColor = nil
                return
            }
            layer.borderColor = color.cgColor
        }
    }
    
    public var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable var shadow: Bool {
        get {
            return layer.shadowOpacity > 0.5
        }
        set {
            if newValue == true {
                self.addShadow()
            }
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return self.layer.cornerRadius
        }
        set {
            self.layer.cornerRadius = newValue
            
            // Don't touch the masksToBound property if a shadow is needed in addition to the cornerRadius
            if shadow == false {
                self.layer.masksToBounds = true
            }
        }
    }
    
    func addShadow(shadowColor: CGColor = UIColor.black.cgColor,
                   shadowOffset: CGSize = CGSize(width: 1.0, height: 4.0),
                   shadowOpacity: Float = 0.4,
                   shadowRadius: CGFloat = 3.0) {
        
        //shadowButton.layer.shadowOffset = CGSize(width: 10.0, height: 10.0)
        layer.shadowColor = shadowColor
        layer.shadowOffset = shadowOffset
        layer.shadowOpacity = shadowOpacity
        layer.shadowRadius = shadowRadius
    }
    
    // HEIGHT / WIDTH
    var width:CGFloat {
        return self.frame.size.width
    }
    var height:CGFloat {
        return self.frame.size.height
    }
    var xPos:CGFloat {
        return self.frame.origin.x
    }
    var yPos:CGFloat {
        return self.frame.origin.y
    }
    
    // ROTATE
    func rotate(_ angle: CGFloat) {
        //let radians = angle / 180.0 * CGFloat(M_PI)
        //self.transform = self.transform.rotated(by: radians);
    }
    
    func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
    
    // BORDER
    func applyBorderDefault() {
        self.applyBorder(UIColor.red, width: 1.0)
    }
    func applyBorderDefault1() {
        self.applyBorder(UIColor.green, width: 1.0)
    }
    func applyBorderDefault2() {
        self.applyBorder(UIColor.blue, width: 1.0)
    }
    func applyBorder(_ color:UIColor, width:CGFloat) {
        self.layer.borderColor = color.cgColor
        self.layer.borderWidth = width
    }
    
    func applyBorderDefault3() {
        self.applyEdgeBorder([.bottom], UIColor.APP_LIGHTBROWN_COLOR(), width: 1.0)
    }
    
    func applyEdgeBorder(_ edge : UIRectEdge, _ color:UIColor, width:CGFloat) {
        self.layer.borderColor = color.cgColor
        self.layer.borderWidth = width
    }
    
    func applyCircle() {
        self.layer.cornerRadius = min(self.frame.size.height, self.frame.size.width) * 0.5
        self.layer.masksToBounds = true
    }
    func applyCircleWithRadius(_ radius:CGFloat) {
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = true
    }
    
    // CORNER RADIUS
    func applyCornerRadius(_ radius:CGFloat) {
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = true
    }
    
    func applyCornerRadiusDefault() {
        self.applyCornerRadius(10.0)
    }
    
    func applyShadowDefault()    {
        self.applyShadowWithColor(UIColor.lightGray, opacity: 1.0, radius: 2)
    }
    
    func applyShadowWithColor(_ color:UIColor)    {
        self.applyShadowWithColor(color, opacity: 2.0, radius: 5)
    }
    
    // Single UIView
    func applyShadowDefaultSet()    {
        self.applyShadowWithColorSet(UIColor.lightGray, opacity: 1.0, radius: 2)
    }
    
    func applyShadowWithColorSet(_ color:UIColor, opacity:Float, radius: CGFloat)    {
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOpacity = opacity
        self.layer.shadowOffset = CGSize(width: 5.0, height: 5.0)
        self.layer.shadowRadius = radius
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = false
        self.clipsToBounds = false
    }
    
    func applyRadiousRight(_ height : CGFloat, _ width : CGFloat) {
        let rectShape = CAShapeLayer()
        rectShape.bounds = self.frame
        rectShape.position = self.center
        rectShape.path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: [.bottomRight , .topRight], cornerRadii: CGSize(width: width, height: height)).cgPath
        self.layer.mask = rectShape
    }
    
    func applyRadiousLeft(_ height : CGFloat, _ width : CGFloat) {
        let rectShape = CAShapeLayer()
        rectShape.bounds = self.frame
        rectShape.position = self.center
        rectShape.path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: [.bottomLeft , .topLeft], cornerRadii: CGSize(width: width, height: height)).cgPath
        self.layer.mask = rectShape
    }
    
    func applyRadiousTopLeftRightBottom(_ height : CGFloat, _ width : CGFloat) {
        let rectShape = CAShapeLayer()
        rectShape.bounds = self.frame
        rectShape.position = self.center
        rectShape.path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: [.topLeft, .bottomRight], cornerRadii: CGSize(width: width, height: height)).cgPath
        self.layer.mask = rectShape
    }
    
    func applyViewroundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
    
    func applyRadiousBottomLeftRightTop(_ height : CGFloat, _ width : CGFloat) {
        let rectShape = CAShapeLayer()
        rectShape.bounds = self.frame
        rectShape.position = self.center
        rectShape.path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: [.bottomLeft, .topRight], cornerRadii: CGSize(width: width, height: height)).cgPath
        self.layer.mask = rectShape
    }
    
    func applyShadowWithColor(_ color:UIColor, opacity:Float, radius: CGFloat)    {
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOpacity = opacity
        self.layer.shadowOffset = CGSize(width: 0, height: 1)
        self.layer.shadowRadius = radius
        self.clipsToBounds = false
    }
    
    //WITH CORNER
    func applyShadowDefault_Corner(_ corners: UIRectEdge) {
        self.applyShadowWithColor_Corner(UIColor.lightGray, opacity: 1.0, radius: 10, corners)
    }
    
    func applyShadowWithColor_Corner(_ color:UIColor, opacity:Float, radius: CGFloat, _ corners: UIRectEdge)    {
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOpacity = opacity
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.layer.shadowRadius = radius
        self.clipsToBounds = false
    }
    
    func dropShadow(color: UIColor, opacity: Float = 0.5, offSet: CGSize, radius: CGFloat = 1, scale: Bool = true) {
        self.layer.masksToBounds = false
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOpacity = opacity
        self.layer.shadowOffset = offSet
        self.layer.shadowRadius = radius
        
        self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
    
    //GRADIANT COLOR
    func applyGradient(colours: [UIColor]) -> Void {
        self.applyGradient(colours: colours, locations: nil)
    }
    
    func applyGradient(colours: [UIColor], locations: [NSNumber]?) -> Void {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.colors = colours.map { $0.cgColor }
        gradient.locations = locations
        self.layer.insertSublayer(gradient, at: 0)
    }
    
    //    extension UIView {
    class func loadFromNibNamed(nibNamed: String, bundle : Bundle? = nil) -> UIView? {
        return UINib(
            nibName: nibNamed,
            bundle: bundle
            ).instantiate(withOwner: nil, options: nil)[0] as? UIView
    }
}

extension UIDevice
{
    // Device Family : iPhone,iPad, ...
    public var deviceFamily: String {
        return UIDevice.current.model
    }
    
    //Device Model : iPhone 6, iPhone 6 plus, iPad Air, ...
    public var deviceModel: String {
        
        var model : String
        let deviceCode = UIDevice().deviceModel
        switch deviceCode
        {
        case "iPod1,1":
            model = "iPod Touch 1G"
        case "iPod2,1":
            model = "iPod Touch 2G"
        case "iPod3,1":
            model = "iPod Touch 3G"
        case "iPod4,1":
            model = "iPod Touch 4G"
        case "iPod5,1":
            model = "iPod Touch 5G"
        case "iPod7,1":
            model = "iPod Touch 6G"
            
        case "iPhone1,1":
            model = "iPhone 2G"
        case "iPhone1,2":
            model = "iPhone 3G"
        case "iPhone2,1":
            model = "iPhone 3GS"
        case "iPhone3,1", "iPhone3,2", "iPhone3,3":
            model = "iPhone 4"
        case "iPhone3,1", "iPhone3,2", "iPhone3,3":
            model = "iPhone 4"
            
        case "iPhone4,1":
            model = "iPhone 4S"
        case "iPhone5,1", "iPhone5,2":
            model = "iPhone 5"
        case "iPhone5,3", "iPhone5,4":
            model = "iPhone 5C"
        case "iPhone6,1", "iPhone6,2":
            model = "iPhone 5S"
        case "iPhone7,2":
            model = "iPhone 6"
        case "iPhone7,1":
            model = "iPhone 6 Plus"
        case "iPhone8,1":
            model = "iPhone 6S"
        case "iPhone8,2":
            model = "iPhone 6S Plus"
            
        case "iPad1,1":
            model = "iPad 1"
        case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":
            model = "iPad 2"
        case "iPad3,1", "iPad3,2", "iPad3,3":
            model = "iPad 3"
        case "iPad3,4", "iPad3,5", "iPad3,6":
            model = "iPad 4"
        case "iPad4,1", "iPad4,2", "iPad4,3":
            model = "iPad Air"
        case "iPad5,1", "iPad5,3", "iPad5,4":
            model = "iPad Air 2"
        case "iPad2,5", "iPad2,6", "iPad2,7":
            model = "iPad Mini"
        case "iPad4,4", "iPad4,5", "iPad4,6":
            model = "iPad Mini 2"
        case "iPad4,7", "iPad4,8", "iPad4,9":
            model = "iPad Mini 3"
        case "iPad5,1", "iPad5,2":
            model = "iPad Mini 4"
        case "iPad6,7", "iPad6,8":
            model = "iPad Pro"
            
        case "i386", "x86_64":
            model = "Simulator"
        default:
            model = deviceCode
        }
        return model
    }
    
    //Device iOS Version : 8.1, 8.1.3, ...
    public var deviceIOSVersion: String {
        return UIDevice.current.systemVersion
    }
    
    public var deviceOrientationString: String {
        var orientation : String
        switch UIDevice.current.orientation{
        case .portrait:
            orientation="Portrait"
        case .portraitUpsideDown:
            orientation="Portrait Upside Down"
        case .landscapeLeft:
            orientation="Landscape Left"
        case .landscapeRight:
            orientation="Landscape Right"
        case .faceUp:
            orientation="Face Up"
        case .faceDown:
            orientation="Face Down"
        default:
            orientation="Unknown"
        }
        return orientation
    }
}

extension NSDate
{
    // APP SPECIFIC FORMATS
    func app_stringFromDate() -> String{
        let dateFormatter:DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        let strdt = dateFormatter.string(from: self as Date)
        if let dtDate = dateFormatter.date(from: strdt){
            return dateFormatter.string(from: dtDate)
        }
        return "--"
    }
    
    func app_dateFormatString() -> String{
        return "\(self.dayOneDigit) \(self.monthNameShort.uppercased()), \(self.dayNameShort.uppercased())"
    }
    
    func app_dateFormatStringShort() -> String{
        return "\(self.dayOneDigit) \(self.monthNameShort.uppercased())"
    }
    
    func app_dateFormatStringForReview() -> String{
        return "\(self.dayOneDigit) \(self.monthNameShort.capitalized), \(self.yearFourDigit)"
    }
    
    func app_dateFormatStringForCreditCardDate() -> String{
        return "\(self.monthNameShort.capitalized), \(self.yearFourDigit)"
    }
    
    func app_dateFormatStringForPlaceOrder() -> String{
        return "\(self.yearFourDigit)-\(self.monthTwoDigit)-\(self.dayTwoDigit)"
    }
    
    func getUTCFormateDate(localDate: NSDate) -> String {
        
        let dateFormatter: DateFormatter = DateFormatter()
        let timeZone: NSTimeZone = NSTimeZone(name: "UTC")!
        dateFormatter.timeZone = timeZone as TimeZone!
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm"
        let dateString: String = dateFormatter.string(from: localDate as Date)
        return dateString
    }
    
    func isGreaterThanDate(dateToCompare: NSDate) -> Bool {
        //Declare Variables
        var isGreater = false
        
        //Compare Values
        if self.compare(dateToCompare as Date) == ComparisonResult.orderedDescending {
            isGreater = true
        }
        //Return Result
        return isGreater
    }
    
    func isLessThanDate(dateToCompare: NSDate) -> Bool {
        //Declare Variables
        var isLess = false
        
        //Compare Values
        if self.compare(dateToCompare as Date) == ComparisonResult.orderedAscending {
            isLess = true
        }
        
        //Return Result
        return isLess
    }
    
    func equalToDate(dateToCompare: NSDate) -> Bool {
        //Declare Variables
        var isEqualTo = false
        
        //Compare Values
        if self.compare(dateToCompare as Date) == ComparisonResult.orderedSame {
            isEqualTo = true
        }
        
        //Return Result
        return isEqualTo
    }
    
    func isEqualToDateWithoutTime(dateToCompareWith:NSDate) -> Bool {
        if(self.dayTwoDigit_Int == dateToCompareWith.dayTwoDigit_Int &&
            self.monthTwoDigit_Int == dateToCompareWith.monthTwoDigit_Int &&
            self.yearFourDigit_Int == dateToCompareWith.yearFourDigit_Int){
            return true
        }else{
            return false
        }
    }
    
    // TIME
    var timeWithAMPM: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        return dateFormatter.string(from: self as Date)
    }
    // YEAR
    var yearFourDigit_Int: Int {
        return Int(self.yearFourDigit)!
    }
    
    var yearOneDigit: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "y"
        return dateFormatter.string(from: self as Date)
    }
    var yearTwoDigit: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yy"
        return dateFormatter.string(from: self as Date)
    }
    var yearFourDigit: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy"
        return dateFormatter.string(from: self as Date)
    }
    
    // MONTH
    var monthOneDigit_Int: Int {
        return Int(self.monthOneDigit)!
    }
    var monthTwoDigit_Int: Int {
        return Int(self.monthTwoDigit)!
    }
    
    var monthOneDigit: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "M"
        return dateFormatter.string(from: self as Date)
    }
    var monthTwoDigit: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM"
        return dateFormatter.string(from: self as Date)
    }
    var monthNameShort: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM"
        return dateFormatter.string(from: self as Date)
    }
    var monthNameFull: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM"
        return dateFormatter.string(from: self as Date)
    }
    var monthNameFirstLetter: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMMM"
        return dateFormatter.string(from: self as Date)
    }
    
    // DAY
    var dayOneDigit_Int: Int {
        return Int(self.dayOneDigit)!
    }
    var dayTwoDigit_Int: Int {
        return Int(self.dayTwoDigit)!
    }
    
    var dayOneDigit: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d"
        return dateFormatter.string(from: self as Date)
    }
    var dayTwoDigit: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd"
        return dateFormatter.string(from: self as Date)
    }
    var dayNameShort: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "E"
        return dateFormatter.string(from: self as Date)
    }
    var dayNameFull: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: self as Date)
    }
    var dayNameFirstLetter: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEEE"
        return dateFormatter.string(from: self as Date)
    }
    
    // AM PM
    var AM_PM: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "a"
        return dateFormatter.string(from: self as Date)
    }
    
    // HOUR
    var hourOneDigit_Int: Int {
        return Int(self.hourOneDigit)!
    }
    var hourTwoDigit_Int: Int {
        return Int(self.hourTwoDigit)!
    }
    var hourOneDigit24Hours_Int: Int {
        return Int(self.hourOneDigit24Hours)!
    }
    var hourTwoDigit24Hours_Int: Int {
        return Int(self.hourTwoDigit24Hours)!
    }
    var hourOneDigit: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h"
        return dateFormatter.string(from: self as Date)
    }
    var hourTwoDigit: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh"
        return dateFormatter.string(from: self as Date)
    }
    var hourOneDigit24Hours: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "H"
        return dateFormatter.string(from: self as Date)
    }
    var hourTwoDigit24Hours: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH"
        return dateFormatter.string(from: self as Date)
    }
    
    // MINUTE
    var minuteOneDigit_Int: Int {
        return Int(self.minuteOneDigit)!
    }
    var minuteTwoDigit_Int: Int {
        return Int(self.minuteTwoDigit)!
    }
    
    var minuteOneDigit: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "m"
        return dateFormatter.string(from: self as Date)
    }
    var minuteTwoDigit: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "mm"
        return dateFormatter.string(from: self as Date)
    }
    
    
    // SECOND
    var secondOneDigit_Int: Int {
        return Int(self.secondOneDigit)!
    }
    var secondTwoDigit_Int: Int {
        return Int(self.secondTwoDigit)!
    }
    
    var secondOneDigit: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "s"
        return dateFormatter.string(from: self as Date)
    }
    var secondTwoDigit: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "ss"
        return dateFormatter.string(from: self as Date)
    }
}

extension UITableView {
    
    func showLoadingFooter(){
        let loadingFooter = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        loadingFooter.frame.size.height = 50
        loadingFooter.hidesWhenStopped = true
        loadingFooter.startAnimating()
        tableFooterView = loadingFooter
    }
    
    func hideLoadingFooter(){
        let tableContentSufficentlyTall = (contentSize.height > frame.size.height)
        let atBottomOfTable = (contentOffset.y >= contentSize.height - frame.size.height)
        if atBottomOfTable && tableContentSufficentlyTall {
            UIView.animate(withDuration: 0.2, animations: {
                self.contentOffset.y = self.contentOffset.y - 50
            }, completion: { finished in
                self.tableFooterView = UIView()
            })
        } else {
            self.tableFooterView = UIView()
        }
    }
    
    func isLoadingFooterShowing() -> Bool {
        return tableFooterView is UIActivityIndicatorView
    }
}

public extension UIWindow
{
    var visibleViewController: UIViewController? {
        return UIWindow.getVisibleViewControllerFrom(vc: self.rootViewController)
    }
    
    static func getVisibleViewControllerFrom(vc: UIViewController?) -> UIViewController?
    {
        if let nc = vc as? UINavigationController {
            return UIWindow.getVisibleViewControllerFrom(vc: nc.visibleViewController)
        } else if let tc = vc as? UITabBarController {
            return UIWindow.getVisibleViewControllerFrom(vc: tc.selectedViewController)
        } else {
            if let pvc = vc?.presentedViewController {
                return UIWindow.getVisibleViewControllerFrom(vc: pvc)
            } else {
                return vc
            }
        }
    }
}

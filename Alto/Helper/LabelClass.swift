//
//  LabelClass.swift
//  EatDiggerCustomer
//
//  Created by Ramneet Singh on 09/05/18.
//  Copyright © 2018 Ramneet Singh. All rights reserved.
//

import Foundation
import UIKit


public extension UIDevice {
    
    var iPhone: Bool {
        return UIDevice().userInterfaceIdiom == .phone
    }
    var iPad: Bool {
        return UIDevice().userInterfaceIdiom == .pad
    }
    
    enum ScreenType: String {
        case iPhone4
        case iPhone5
        case iPhone6
        case iPhone6Plus
        case iPhoneX
        case iPad
        case Unknown
    }
    
    var screenType: ScreenType {
        
        // guard iPhone else { return .Unknown}
        switch UIScreen.main.nativeBounds.height {
        case 960:
            return .iPhone4
        case 1136:
            return .iPhone5
        case 1334:
            return .iPhone6
        case 2208, 1920:
            return .iPhone6Plus
        case 2436:
            return .iPhoneX
        case 2048.0:
            return .iPad
        default:
            return .Unknown
        }
    }
}


class DynamicSizeLabel : UILabel {
    required init(coder aDecoder: (NSCoder?)) {
        super.init(coder: aDecoder!)!
      
        switch UIDevice().screenType {
        case .iPhone4, .iPhone5:  // iPhone 4 & iPhone 5
            self.font = UIFont(name: (self.font.fontName), size: font.pointSize - 2)
            break
        case .iPhone6:            // iPhone 6 & iPhone 7
            self.font = UIFont(name: (self.font.fontName), size: font.pointSize)
            break
        case .iPhone6Plus:        // iPhone 6 Plus & iPhone 7 Plus
            self.font = UIFont(name: (self.font.fontName), size: font.pointSize + 4)
            break
        case .iPhoneX:            // iPhone X
            self.font = UIFont(name: (self.font.fontName), size: font.pointSize)
            break
        case .iPad:               // iPad
            self.font = UIFont(name: (self.font.fontName), size: font.pointSize + 6)
            break
        default:
            break
        }
       
    }
}

class Dynamic_Greater_SizeLabel : UILabel {
    required init(coder aDecoder: (NSCoder?)) {
        super.init(coder: aDecoder!)!
        
        switch UIDevice().screenType {
        case .iPhone4, .iPhone5:  // iPhone 4 & iPhone 5
            self.font = UIFont(name: (self.font.fontName), size: font.pointSize - 2)
            break
        case .iPhone6:            // iPhone 6 & iPhone 7
            self.font = UIFont(name: (self.font.fontName), size: font.pointSize)
            break
        case .iPhone6Plus:        // iPhone 6 Plus & iPhone 7 Plus
            self.font = UIFont(name: (self.font.fontName), size: font.pointSize + 4)
            break
        case .iPhoneX:            // iPhone X
            self.font = UIFont(name: (self.font.fontName), size: font.pointSize)
            break
        case .iPad:               // iPad
            self.font = UIFont(name: (self.font.fontName), size: font.pointSize + 5)
            break
        default:
            break
        }
        
    }
}





class DynamicSizeTextField : UITextField {
    var leftPaddingView : UIView?

    required init(coder aDecoder: (NSCoder?)) {
        super.init(coder: aDecoder!)!
        leftPaddingView = UIView(frame: CGRect.init(x: 0, y: 0, width :12, height:self.frame.height))
        leftViewMode = UITextField.ViewMode.always
        rightViewMode = UITextField.ViewMode.always

        rightView = leftPaddingView
        leftView = leftPaddingView
        if tag == 1{
            self.cornerRadius = self.frame.size.height/2
        }
//        self.attributedPlaceholder = NSAttributedString(string: self.placeholder!,
//                                                        attributes: [NSAttributedString.Key.foregroundColor: UIColor.black])
        self.textColor = UIColor.black
        
        self.font = UIFont.init(name: "FertigoPro-Regular", size: 17)
        
        switch UIDevice().screenType {
        case .iPhone4, .iPhone5:  // iPhone 4 & iPhone 5
            self.font = UIFont.init(name: "FertigoPro-Regular", size: (font?.pointSize)! - 2)
            break
        case .iPhone6:            // iPhone 6 & iPhone 7
            self.font = UIFont.init(name: "FertigoPro-Regular", size: (font?.pointSize)!)
            break
        case .iPhone6Plus:        // iPhone 6 Plus & iPhone 7 Plus
            self.font = UIFont.init(name: "FertigoPro-Regular", size: (font?.pointSize)! + 4)
            break
        case .iPhoneX:            // iPhone X
            self.font =  UIFont.init(name: "FertigoPro-Regular", size: (font?.pointSize)!)
            break
        case .iPad:               // iPad
            self.font = UIFont.init(name: "FertigoPro-Regular", size: (font?.pointSize)! + 7)
            break
        default:
            break
        }
        
    }
}

class DynamicSizeWithImageCountryCodeTextField : UITextField  {
    @IBInspectable var Image : UIImage = #imageLiteral(resourceName: "ic_search"){
        didSet {
            updateView()
        }
    }
    var imgView : UIImageView?
    var paddingView : UIView?
    var leftPaddingView : UIView?
    
    var textCode = UITextField()
    func updateView() {
        imgView = UIImageView.init(frame: CGRect.init(x: (self.frame.size.width - self.frame.size.height/2) - 12 , y:  self.frame.size.height/6 + 2.5 , width: self.frame.size.height/2 - 5, height: self.frame.size.height/2 - 5))
        
        imgView?.image = Image
        imgView?.contentMode = .scaleToFill
        imgView?.clipsToBounds = true
        addSubview(imgView!)
    }
    func UpdateFrame() {
        imgView?.frame = CGRect.init(x: (self.frame.size.width - self.frame.size.height/2) - 12, y:  (self.frame.size.height - self.frame.size.height/2)/2 + 2.5 , width: self.frame.size.height/2 - 5 , height: self.frame.size.height/2 - 5)
        textCode = UITextField.init(frame: CGRect.init(x: (self.frame.size.height - self.frame.size.height/2) + self.frame.size.height/2 , y:   0, width: self.frame.size.height  + 50  , height: self.frame.size.height))
        textCode.placeholder = "Code"
        textCode.leftViewMode = UITextField.ViewMode.always
        textCode.textAlignment = .center
        textCode.keyboardType = .numberPad
        
        
        
        
        paddingView = UIView(frame: CGRect.init(x: 0, y: 0, width :self.frame.size.height, height:self.frame.height))
        
        rightView = paddingView
        leftView = textCode
        
        imgView?.setImageColor(color: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1))
        rightViewMode = UITextField.ViewMode.always
        leftViewMode = UITextField.ViewMode.always
        
        
    }
    required init(coder aDecoder: (NSCoder?)) {
        super.init(coder: aDecoder!)!
        
        
        if tag == 1{
            self.cornerRadius = self.frame.size.height/2
        }
        self.attributedPlaceholder = NSAttributedString(string: self.placeholder!,
                                                        attributes: [NSAttributedString.Key.foregroundColor: UIColor.black])
        self.textColor = UIColor.black
        self.font = UIFont.init(name: SystemFont.FontFamilyName, size: 17)
        switch UIDevice().screenType {
        case .iPhone4, .iPhone5:  // iPhone 4 & iPhone 5
            self.font = UIFont.init(name: SystemFont.FontFamilyName, size: (font?.pointSize)! - 2)
            break
        case .iPhone6:            // iPhone 6 & iPhone 7
            self.font = UIFont.init(name: SystemFont.FontFamilyName, size: (font?.pointSize)!)
            break
        case .iPhone6Plus:        // iPhone 6 Plus & iPhone 7 Plus
            self.font = UIFont.init(name: SystemFont.FontFamilyName, size: (font?.pointSize)! + 4)
            break
        case .iPhoneX:            // iPhone X
            self.font =  UIFont.init(name: SystemFont.FontFamilyName, size: (font?.pointSize)!)
            break
        case .iPad:               // iPad
            self.font = UIFont.init(name: SystemFont.FontFamilyName, size: (font?.pointSize)! + 7)
            break
        default:
            break
        }
        
    }
    @IBAction func Code(_ sender: Any) {
        print("top")
    }
    
    
    
}


class DynamicSizeWithImageTextField : UITextField {
    @IBInspectable var Image : UIImage = #imageLiteral(resourceName: "ic_password"){
        didSet {
            updateView()
        }
    }
    @IBInspectable var Color : UIColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1){
        didSet {
            updateColor()
        }
    }
    var imgView : UIImageView?
    var paddingView : UIView?
    var leftPaddingView : UIView?

    func updateView() {
         imgView = UIImageView.init(frame: CGRect.init(x: (self.frame.size.width - self.frame.size.height/2) - 12 , y:  self.frame.size.height/6 + 2.5 , width: self.frame.size.height/2 - 5 , height: self.frame.size.height/2 - 5))
       
        imgView?.image = Image
        imgView?.contentMode = .scaleToFill
        imgView?.clipsToBounds = true
        addSubview(imgView!)
    }
    func updateColor() {
        self.attributedPlaceholder = NSAttributedString(string: self.placeholder!,
                                                        attributes: [NSAttributedString.Key.foregroundColor: Color])
        self.textColor = Color
    }
    func UpdateFrame() {
//        if  UIDevice.modelName.contains("iPad"){
            imgView?.frame = CGRect.init(x: (self.frame.size.width - self.frame.size.height/2) - 12, y:  (self.frame.size.height - self.frame.size.height/2)/2 + 2.5 , width: self.frame.size.height/2 - 5, height: self.frame.size.height/2 - 5)
        
        
            paddingView = UIView(frame: CGRect.init(x: 0, y: 0, width :self.frame.size.height, height:self.frame.height))
        leftPaddingView = UIView(frame: CGRect.init(x: 0, y: 0, width :self.frame.size.height/2, height:self.frame.height))

            rightView = paddingView
            leftView = leftPaddingView

            imgView?.setImageColor(color: Color)
            rightViewMode = UITextField.ViewMode.always
        leftViewMode = UITextField.ViewMode.always

//        }
    }
 
    required init(coder aDecoder: (NSCoder?)) {
        super.init(coder: aDecoder!)!
      
        
        if tag == 1{
            self.cornerRadius = self.frame.size.height/2
        }
        self.attributedPlaceholder = NSAttributedString(string: self.placeholder!,
                                                        attributes: [NSAttributedString.Key.foregroundColor: Color])
        self.textColor = Color
        
        self.font = UIFont.init(name: SystemFont.FontFamilyName, size: 17)
        
        switch UIDevice().screenType {
        case .iPhone4, .iPhone5:  // iPhone 4 & iPhone 5
            self.font = UIFont.init(name: SystemFont.FontFamilyName, size: (font?.pointSize)! - 2)
            break
        case .iPhone6:            // iPhone 6 & iPhone 7
            self.font = UIFont.init(name: SystemFont.FontFamilyName, size: (font?.pointSize)!)
            break
        case .iPhone6Plus:        // iPhone 6 Plus & iPhone 7 Plus
            self.font = UIFont.init(name: SystemFont.FontFamilyName, size: (font?.pointSize)! + 4)
            break
        case .iPhoneX:            // iPhone X
            self.font =  UIFont.init(name: SystemFont.FontFamilyName, size: (font?.pointSize)!)
            break
        case .iPad:               // iPad
            self.font = UIFont.init(name: SystemFont.FontFamilyName, size: (font?.pointSize)! + 7)
            break
        default:
            break
        }
        
    }
    
}
extension UIImageView {
    func setImageColor(color: UIColor) {
        let templateImage = self.image?.withRenderingMode(.alwaysTemplate)
        self.image = templateImage
        self.tintColor = color
    }
}
extension UILabel {
    @IBInspectable
    var rotation: Int {
        get {
            return 0
        } set {
            let radians = CGFloat(CGFloat(Double.pi) * CGFloat(newValue) / CGFloat(180.0))
            self.transform = CGAffineTransform(rotationAngle: radians)
        }
    }
}

class customLabelSize: UILabel {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        customSize()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        customSize()
    }
    private func customSize() {
        
        
        
    }
}



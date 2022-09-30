//
//  CheckTextField.swift
//  EatDiggerCustomer
//
//  Created by Jaypreet on 14/06/18.
//  Copyright © 2018 Ramneet Singh. All rights reserved.
//

import Foundation
import UIKit


enum TextFieldType {
    case Email
    case Password
    case PhoneNumber
    case CountryCode

    case PasswordCreate
    case Username

    case Default
}

extension UITextField{
    func AddRightDropDownIcon(icon : UIImage)  {
        let vi = UIView.init(frame: CGRect.init(x:  -10, y: 0, width: frame.size.height - 20  , height: frame.size.height - 20))
        let img = UIImageView.init(image: icon)
        img.frame = vi.frame
        img.contentMode = .scaleAspectFit
        img.isUserInteractionEnabled = false
        vi.isUserInteractionEnabled = false

        vi.addSubview(img)
        self.rightView = vi
        self.rightViewMode = .always
    }
    
}

extension UITextField{
    func CheckText(_ Type : TextFieldType = .Default ) -> Bool {
        
        switch Type {
        case .Username:
                  print("Username")
                  
                  if text!.contains(" ") || text!.count == 0 {
                    self.layer.borderColor = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
                    Constants.Toast.MyToast(message: TextStrings.MESSAGE.CommonTextfieldMethod + " \(placeholder!)", image:#imageLiteral(resourceName: "exclamationCircle"))
                    return false


                  }
                  else{
                    self.layer.borderColor = UIColor.main_Border_Color().cgColor

                  }
                  
                  return true
        case .Email:
            print("Email")
            let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
            
            let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
            if emailTest.evaluate(with: text) == false{
                self.layer.borderColor = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)

                Constants.Toast.MyToast(message: TextStrings.MESSAGE.EMPTY_Email, image: #imageLiteral(resourceName: "exclamationCircle"))
            }
            else{
                self.layer.borderColor = UIColor.main_Border_Color().cgColor

            }
            return emailTest.evaluate(with: text)
        case .Password:
            print("Password")
            if text!.contains(" "){
                self.layer.borderColor = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)

                Constants.Toast.MyToast(message: TextStrings.MESSAGE.Invalid_password, image: #imageLiteral(resourceName: "exclamationCircle"))
                    return false
            }
            if text!.count < 5{
                self.layer.borderColor = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)

                Constants.Toast.MyToast(message: TextStrings.MESSAGE.Invalid_password, image: #imageLiteral(resourceName: "exclamationCircle"))
                    return false
            }
            self.layer.borderColor = UIColor.main_Border_Color().cgColor

            return true
        case .PasswordCreate:
            print("Password")
                    
            let passwordTest = NSPredicate(format: "SELF MATCHES %@ ",  "^(?=.*[A-Z])(?=.*[!@#$%^&*()_+?><|?])(?=.*[0-9])(?=.*[a-z]).{8,}$")
            if !passwordTest.evaluate(with: text!) {
                self.layer.borderColor = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)

                Constants.Toast.MyToast(message: TextStrings.MESSAGE.EMPTY_Password, image: #imageLiteral(resourceName: "exclamationCircle") , time: DispatchTime.now() + 4)
                return false
            }
            self.layer.borderColor = UIColor.main_Border_Color().cgColor

            return true
        case .CountryCode:
            print("CountryCode")
            if text!.count == 0{
                self.layer.borderColor = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)

                Constants.Toast.MyToast(message: TextStrings.MESSAGE.EMPTY_CountryCode, image: #imageLiteral(resourceName: "exclamationCircle"))
                return false
            }
            self.layer.borderColor = UIColor.main_Border_Color().cgColor

            return true
        case .PhoneNumber:
            print("PhoneNumber")
            if text!.count < 9{
                self.layer.borderColor = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)

                Constants.Toast.MyToast(message: TextStrings.MESSAGE.EMPTY_Phone, image: #imageLiteral(resourceName: "exclamationCircle"))
                return false
            }
            self.layer.borderColor = UIColor.main_Border_Color().cgColor

            return true
        case .Default:
            print("Default")
            if text!.count == 0{
                self.layer.borderColor = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)

                Constants.Toast.MyToast(message: TextStrings.MESSAGE.CommonTextfieldMethod + " \(placeholder ?? "")", image:#imageLiteral(resourceName: "exclamationCircle"))
                return false
            }
            self.layer.borderColor = UIColor.main_Border_Color().cgColor

            return true
        }
    }
    
    func MatchPassword(txt : UITextField) -> Bool {
        if text! != txt.text!{
            self.layer.borderColor = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)

            Constants.Toast.MyToast(message: TextStrings.MESSAGE.EMPTY_Password_match, image: #imageLiteral(resourceName: "exclamationCircle"))
            return false
        }
        self.layer.borderColor = UIColor.main_Border_Color().cgColor

        return true
    }
   
}



class CheckTextField: NSObject {
    func CheckText(text : String , String_type : String , view : Any) -> Bool {
         if text.count == 0 {
            if view is UITextView{
                (view as! UITextView).layer.borderColor = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
            }
            if view is UITextField{
                (view as! UITextField).layer.borderColor = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
            }

               Constants.Toast.MyToast(message: TextStrings.MESSAGE.CommonTextfieldMethod + " \(String_type)", image:#imageLiteral(resourceName: "exclamationCircle"))
             return false
         }
        if view is UITextView{
            (view as! UITextView).layer.borderColor = UIColor.main_Border_Color().cgColor
        }
        if view is UITextField{
            (view as! UITextField).layer.borderColor = UIColor.main_Border_Color().cgColor
        }
         return true
    }
    func CheckTermsAndConditions(isChecked : Bool) -> Bool {
        if isChecked != true{
              Constants.Toast.MyToast(message: TextStrings.MESSAGE.CheckTermAndConditon, image:#imageLiteral(resourceName: "exclamationCircle"))
            return false
        }
        return true
    }
}

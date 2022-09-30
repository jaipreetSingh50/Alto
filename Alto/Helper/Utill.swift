


//
//  Utill.swift
//  Orem_Assignment
//
//  Created by Nikhil_Mac on 3/24/18.
//  Copyright © 2018 Nikhil_Mac. All rights reserved.
//

import Foundation
import UIKit
import MessageUI


class Utill
{
    static func drawShadow(layer:CALayer)
    {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.2
        layer.shadowRadius = 5
    }
    
    
    static func dropShadow(layer:CALayer)
    {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.3
        layer.shadowOffset = CGSize(width: 1, height: 1)
        layer.shadowRadius = 4
        
    }
    
    static func drawGradient(view:UIView , color1 : UIColor , color2 : UIColor)
    {
        
        
        
        let gradient = CAGradientLayer()
        
        gradient.frame = CGRect.init(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height)
        gradient.colors = [color1.cgColor,color2.cgColor, color1.cgColor ]
      
        
        
        view.layer.insertSublayer(gradient, at: 180)
    }
    static func SetViewCorner(view:UIView , borderColor : CGColor , cornerRadiu : CGFloat , borderWidth : CGFloat)
    {
        if view is UIImageView{
            view.layer.masksToBounds = true
        }
        
        view.layer.cornerRadius = cornerRadiu
        view.layer.borderWidth = borderWidth
        view.layer.borderColor = borderColor
        
    }
    static func SetButtonCorner(button:UIView , borderColor : CGColor , cornerRadiu : CGFloat , borderWidth : CGFloat)
    {
        
        button.layer.cornerRadius = cornerRadiu
        button.layer.borderWidth = borderWidth
        button.layer.borderColor = borderColor
        
    }
    
    
    static func openDialingScreen(parent:UIViewController)
    {
       
        let number = "12345"
        let sms = "tel://\(number)"
        let url = URL(string:sms)!
        let shared = UIApplication.shared
        
        if(shared.canOpenURL(url)){
            shared.openURL(url)
        }else{
            
            
            showDialog(message: "Calling services are not available",parent: parent) { (status) in
                if status == 1{
                   
                }
            }
        
        }
    }
    
    static func openMessageScreen(parent:UIViewController)
    {
        
        if !MFMessageComposeViewController.canSendText() {
            print("SMS services are not available")
            showDialog(message: "SMS services are not available", parent: parent){ (status) in
                if status == 1{
                   
                }
            }
        }
            
        else
        {
            let composeVC = MFMessageComposeViewController()
            //composeVC.messageComposeDelegate = self
            
            // Configure the fields of the interface.
            composeVC.recipients = ["4085551212"]
            composeVC.body = "Hello text message!"
            
            // Present the view controller modally.
            parent.present(composeVC, animated: true, completion: nil)
            
        }
        
        
       
        
    }
    static func showLocationSettingDialog(parent:UIViewController)
    {
        let refreshAlert = UIAlertController(title: TextStrings.BUTTON.Alert, message: TextStrings.MESSAGE.LocationRequired , preferredStyle: UIAlertController.Style.alert)
        
        refreshAlert.addAction(UIAlertAction(title: TextStrings.BUTTON.Setting, style: .default, handler: { (action: UIAlertAction!) in
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString + Bundle.main.bundleIdentifier!) else {
                return
            }
            
            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                    // Checking for setting is opened or not
                    print("Setting is opened: \(success)")
                })
            }
        }))
        refreshAlert.addAction(UIAlertAction(title: TextStrings.BUTTON.CANCEL, style: .cancel, handler: { (action: UIAlertAction!) in
            
        }))
        
        
        parent.present(refreshAlert, animated: true, completion: nil)
    }
    static func showLoginDialog(toHome : Bool, parent:UIViewController , storyBoard : UIStoryboard)
    {
        let refreshAlert = UIAlertController(title: TextStrings.BUTTON.Alert, message: TextStrings.MESSAGE.Logged_Out_Login_Again, preferredStyle: UIAlertController.Style.alert)
        
        refreshAlert.addAction(UIAlertAction(title: TextStrings.BUTTON.Login, style: .default, handler: { (action: UIAlertAction!) in
//               let vc = storyBoard.instantiateViewController(withIdentifier: Constants.VIEW_IDENTIFIER.LoginViewController) as! LoginViewController
//                parent.present(vc, animated: true, completion: nil)
          }))
        refreshAlert.addAction(UIAlertAction(title: TextStrings.BUTTON.CANCEL, style: .cancel, handler: { (action: UIAlertAction!) in
            if toHome == true{
                Utill.presentFromView(identifier: "TabViewController", viewC: parent, storyboard: storyBoard, dict: [:], animated: false)
            }
        }))
        
        
        parent.present(refreshAlert, animated: true, completion: nil)
    }
    static func showDialog(message:String,parent:UIViewController , withCompletionHandler:@escaping (_ Status:Int  ) -> Void)
    {
        let refreshAlert = UIAlertController(title: TextStrings.BUTTON.Alert, message: message, preferredStyle: UIAlertController.Style.alert)
        
        refreshAlert.addAction(UIAlertAction(title: TextStrings.BUTTON.OK, style: .default, handler: { (action: UIAlertAction!) in
            withCompletionHandler(1)
        }))
        refreshAlert.addAction(UIAlertAction(title: TextStrings.BUTTON.CANCEL, style: .cancel, handler: { (action: UIAlertAction!) in
            withCompletionHandler(0)

        }))
       
        
        parent.present(refreshAlert, animated: true, completion: nil)
    }
    static func presentFromView(identifier:String , viewC : UIViewController , storyboard : UIStoryboard , dict : [String : Any] , animated : Bool){
        let vc = storyboard.instantiateViewController(withIdentifier: identifier)
        vc.modalPresentationStyle = .fullScreen
        viewC.present(vc, animated: animated, completion: nil)
    }
    static func presentFromViewReturn(identifier:String , viewC : UIViewController , storyboard : UIStoryboard  , withCompletionHandler:@escaping (_ result:UIViewController  ) -> Void){
        let vc = storyboard.instantiateViewController(withIdentifier: identifier)

        viewC.present(vc, animated: true) {
            withCompletionHandler(vc)
        }

    }
    static func presentFullFromViewReturn(identifier:String , viewC : UIViewController , storyboard : UIStoryboard  , withCompletionHandler:@escaping (_ result:UIViewController  ) -> Void){
          let vc = storyboard.instantiateViewController(withIdentifier: identifier)
        vc.modalPresentationStyle = .fullScreen

          viewC.present(vc, animated: true) {
              withCompletionHandler(vc)
          }
    }
    
//
    static func PushFromView(identifier:String , navigation : UINavigationController , storyboard : UIStoryboard ){
        let vc = storyboard.instantiateViewController(withIdentifier: identifier)
        navigation.pushViewController(vc, animated: true)
    }
    static func PresentLangView( navigation : UIViewController  ){
//        let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SetLangViewController") as! SetLangViewController
//        navigation.present(vc, animated: true, completion: nil)
    }
    static func PushFromViewAnimation(identifier:String , navigation : UINavigationController , storyboard :  UIStoryboard , animation : Bool){
        let vc = storyboard.instantiateViewController(withIdentifier: identifier)
        navigation.pushViewController(vc, animated: animation)
    }
    
    static func PopToVC( navigation : UINavigationController){
       navigation.popViewController(animated: true)
    }
    static func Dismiss( viewC : UIViewController){
        viewC.dismiss(animated: true, completion: nil)
    }
    
}
extension String{
    func ShowPrice(price : Double) -> String {
        return self + String(format :"%.2f",price)
    }
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        
        return ceil(boundingBox.height)
    }
    
    func width(withConstrainedHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        
        return ceil(boundingBox.width)
    }
    
    func HTMLtextToString() -> NSAttributedString {
        let modifiedFontString = "<span style=\"font-family: \(SystemFont.FontFamilyNameLight); font-size: 15\">" + self + "</span>"

        guard let data = modifiedFontString.data(using: .utf8) else {
            return NSAttributedString.init(string: "-")
        }

        let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
            .documentType: NSAttributedString.DocumentType.html,
            .characterEncoding: String.Encoding.utf8.rawValue
        ]

        guard let attributedString = try? NSAttributedString(data: data, options: options, documentAttributes: nil) else {
            return NSAttributedString.init(string: "-")
        }
        
        return attributedString
    }
}

class TopViewContriller: UIViewController {
    func SetTheme(_ set : Int = 0 , imgBg : UIImageView , logo : UIImageView)  {
        if set != 0{
            
            
        }
        else{
//            imgBg.image = CommonFunctions().GetTheame(Id: Constants.CurrentUserData.template_type ?? 0).bg
        }
    }
}

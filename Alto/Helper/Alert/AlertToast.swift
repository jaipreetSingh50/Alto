//
//  AlertToast.swift
//  SNAP
//
//  Created by Jaypreet on 21/12/18.
//  Copyright © 2018 Jaypreet. All rights reserved.
//

import Foundation
import UIKit

class AlertToast : NSObject, UIGestureRecognizerDelegate
{


    func MyToast(message:String , color : UIColor = #colorLiteral(red: 0.1019607857, green: 0.2784313858, blue: 0.400000006, alpha: 1) , image : UIImage = Constants.AppLogo , show : Bool = true ,  time : DispatchTime = DispatchTime.now() + 6)
    {
        if !show{
            return
        }
        let Width = 300
        let Height = 90

        let mainView = UIView.init(frame:  CGRect.init(x: 0 , y: -164, width: Int(UIScreen.main.bounds.width), height: Height))
        mainView.backgroundColor = UIColor.clear
        mainView.alpha = 0
        mainView.alpha = 1
        
        let InerView = UIView.init(frame:  CGRect.init(x: 20 , y: 20 , width:  Int(mainView.frame.size.width - 40), height: Height - 20))
        InerView.backgroundColor = Constants.AppColor
        InerView.layer.cornerRadius = 8
        
        let AppImage = UIImageView.init(frame:  CGRect.init(x: 10, y: InerView.frame.height/2 - 10, width: 20, height: 20))
      
        AppImage.image = image
        
        let lblMessage = UILabel.init(frame:  CGRect.init(x: 40, y: 5, width: Int(InerView.bounds.width) - 50, height: 60))
        lblMessage.text = message
        lblMessage.numberOfLines = 0
        lblMessage.textAlignment = .justified
        lblMessage.textColor = color
        lblMessage.minimumScaleFactor = 0.6
        lblMessage.allowsDefaultTighteningForTruncation = true
        
        if UIFont.init(name: SystemFont.FontFamilyName, size: 13) != nil{
            lblMessage.font = UIFont.init(name: SystemFont.FontFamilyName, size: 13)
        }
        else{
            lblMessage.font = UIFont.systemFont(ofSize: 13)
        }

        if image == Constants.AppLogo{
            AppImage.frame =   CGRect.init(x: 10, y: InerView.frame.height/2 - 10, width: 0, height: 20)
            lblMessage.frame =   CGRect.init(x: 10, y: 5, width: Int(InerView.bounds.width) - 20, height: 60)

        }
        
        InerView.addSubview(lblMessage)
        InerView.addSubview(AppImage)
        mainView.addSubview(InerView)
        let clientApp = UIApplication.shared
        var windows = clientApp.windows
        var topWindow : UIWindow? = nil
        if windows.count != 0{
            topWindow = windows[0]
        }
        topWindow?.addSubview(mainView)
        mainView.animateToggleAlpha(status: "Show")
//        let when = DispatchTime.now() + time
        DispatchQueue.main.asyncAfter(deadline: time)
        {
            mainView.animateToggleAlpha(status: "Hide")
            let when = DispatchTime.now() + 1
            DispatchQueue.main.asyncAfter(deadline: when)
            {
                mainView.removeFromSuperview()
            }
        }
     
        let swipeGestureRecognizerDown = UISwipeGestureRecognizer(target: self, action: #selector(didSwipe(_:)))
        swipeGestureRecognizerDown.direction = .up
//        swipeGestureRecognizerDown.direction = .down

        mainView.addGestureRecognizer(swipeGestureRecognizerDown)

    }
    @objc private func didSwipe(_ sender: UISwipeGestureRecognizer) {
        sender.view?.animateToggleAlpha(status: "Hide")
        let when = DispatchTime.now() + 1
        DispatchQueue.main.asyncAfter(deadline: when)
        {
            sender.view?.removeFromSuperview()
        }
        
    }
}
extension UIView {
    
    func animateToggleAlpha(status : String) {
        UIView.animate(withDuration: 0.5) {
            let Height = 130

            if status == "Show"{
                self.frame.origin.y =  30
            }
            else{
                self.frame.origin.y = -(64  + CGFloat(Height) + 20)

            }
        }
    }
}

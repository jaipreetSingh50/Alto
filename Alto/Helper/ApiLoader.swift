//
//  ApiLoader.swift
//  ClickPic
//
//  Created by Jaypreet on 04/05/18.
//  Copyright © 2018 jaipreet singh & Harpreet Singh. All rights reserved.
//

import Foundation
import UIKit
import NVActivityIndicatorView
import IQKeyboardManagerSwift
import AVFoundation
import CoreLocation
import Photos
import Contacts

class ApiLoader : UIView {
    
   
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override init(frame: CGRect) {
        super.init(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.7455318921)
        let img = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        img.backgroundColor = UIColor.clear
//        img.image = UIImage.gifImageWithName("search")
//        let animationView = AnimationView(name: "Search")
//            animationView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width/2, height: UIScreen.main.bounds.width/2)
//            animationView.center = center
//            animationView.contentMode = .scaleAspectFill
////
//            addSubview(animationView)
//            animationView.loopMode = .loop
//
//            animationView.play()
    
    }
    func Show()  {
        isHidden = false
    }
    func Hide()  {
        isHidden = true
    }
    
    static func openDialingScreen(parent:UIViewController){
    }
    
}

enum PromissionType {
    case Camera
    case Location
    case Gallery
    case Audio
    case Contacts
    func get() -> String {
        let appName : String = Bundle.main.infoDictionary!["CFBundleName"] as! String

        switch self {
        case .Camera:
            return "\(appName) will access your Phone Camera for Profile Image."
        case .Location:
            return "\(appName) will access your Location for current location on device."
        case .Gallery:
            return "\(appName) will access your phone library for Profile Image."
        case .Audio:
            return "\(appName) will Need microphone access for "
        case .Contacts:
            return "\(appName) will access your phone book library to add Emergency contacts."

        }
    }

}



extension UIViewController {
    
        
    func AskPromission(type : PromissionType ,_ message : String = "", completion:@escaping ((UIView,Bool) -> Void)) {
        let vi = UIView.init(frame: self.view.bounds)
        print(self.view.frame)
        vi.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.8498864619)
        let btnCancel = UIButton.init(frame: CGRect.init(x: 30, y: view.frame.height/2 + 60, width: view.frame.width - 60, height: 50))
        btnCancel.setTitle("Cancel", for: .normal)
        let can = UIAction.init { (action) in
            vi.removeFromSuperview()
            completion(vi,false)
        }
        if #available(iOS 14.0, *) {
            btnCancel.addAction(can, for: .touchDown)
        } else {
//            btnCancel.addAction(can, for: .touchDown)
            // Fallback on earlier versions
        }
        vi.addSubview(btnCancel)
        
        let lblMessage = UILabel.init(frame: CGRect.init(x: 30, y: 100, width: view.frame.width - 60, height: 150))
        lblMessage.textAlignment = .center
        lblMessage.numberOfLines = 0
        lblMessage.minimumScaleFactor = 0.5
        lblMessage.font = UIFont.boldSystemFont(ofSize: 15)
        lblMessage.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        vi.addSubview(lblMessage)
        let btnSetting = UIButton.init(frame: CGRect.init(x: 30, y: view.frame.height/2, width: view.frame.width - 60, height: 50))
        btnSetting.setTitle("Settings", for: .normal)
        btnSetting.setTitleColor(#colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1), for: .normal)
        btnSetting.titleLabel?.font = UIFont.boldSystemFont(ofSize: 24)
        btnCancel.setTitleColor(#colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1), for: .normal)
        btnCancel.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        let set = UIAction.init { (action) in
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString + Bundle.main.bundleIdentifier!) else {
                completion(vi,false)

                return
            }
            
            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                    // Checking for setting is opened or not
                    print("Setting is opened: \(success)")
                    vi.removeFromSuperview()
                    completion(vi,true)

                })
            }
            
        }
        if #available(iOS 14.0, *) {
            btnSetting.addAction(set, for: .touchDown)
        } else {
            // Fallback on earlier versions
        }
        vi.addSubview(btnSetting)
        lblMessage.text = message;

        if message == ""{
            lblMessage.text = type.get()
        }
        
        switch type {
        case .Camera:
            switch AVCaptureDevice.authorizationStatus(for: .video) {
                case .authorized: // The user has previously granted access to the camera.
                    completion(vi,true)
                    //access granted
                case .notDetermined: // The user has not yet been asked for camera access.
                    AVCaptureDevice.requestAccess(for: .video) { granted in
                        if granted {
                            DispatchQueue.main.async {
                                completion(vi,true)
                            }
                        }
                        else{
                            self.view.addSubview(vi)

                        }
                    }
                case .denied: // The user has previously denied access.
                    self.view.addSubview(vi)
                    return
                case .restricted: // The user can't grant access due to restrictions.
                    self.view.addSubview(vi)

                    return
            }
        case .Audio:
            print("audio")
            switch AVCaptureDevice.authorizationStatus(for: .audio) {
                case .authorized: // The user has previously granted access to the camera.
                    completion(vi,true)
                    //access granted
                case .notDetermined: // The user has not yet been asked for camera access.
                    AVCaptureDevice.requestAccess(for: .video) { granted in
                        if granted {
                            DispatchQueue.main.async {
                                completion(vi,true)
                            }
                        }
                        else{
                            self.view.addSubview(vi)

                        }
                    }
                case .denied: // The user has previously denied access.
                    self.view.addSubview(vi)
                    return
                case .restricted: // The user can't grant access due to restrictions.
                    self.view.addSubview(vi)

                    return
            }
        case .Contacts:
            
            switch CNContactStore.authorizationStatus(for: .contacts) {
             case .notDetermined:
                CNContactStore().requestAccess(for: .contacts) { granted,arg  in
                    if granted {
                        DispatchQueue.main.async {
                            completion(vi,true)
                        }
                    }
                    else{
                        self.view.addSubview(vi)

                    }
                }

            case .authorized:
                completion(vi,true)
             case .denied:
                self.view.addSubview(vi)

             default: return
             }
            
            
            
        case .Location:
            if CLLocationManager.locationServicesEnabled() {
                switch CLLocationManager.authorizationStatus() {
                case .notDetermined:
                        print("No access")
                    let locationManager = CLLocationManager()
                    locationManager.requestAlwaysAuthorization()
                    locationManager.requestWhenInUseAuthorization()
                    
                    completion(vi,true)

                    
                    
                case .restricted, .denied:
                    self.view.addSubview(vi)
                case .authorizedAlways, .authorizedWhenInUse:
                        print("Access")
                        completion(vi,true)
                    @unknown default:
                    break
                }
            } else {
                self.view.addSubview(vi)
            }
        case .Gallery:
            let photos = PHPhotoLibrary.authorizationStatus()
            if photos == .notDetermined {
                PHPhotoLibrary.requestAuthorization({status in
                    if status == .authorized{
                        completion(vi,true)
                    } else {
                        self.view.addSubview(vi)

                    }
                })
            }
            else if photos == .authorized{
                completion(vi,true)

            }
            else{
                self.view.addSubview(vi)

            }

        default:
            break
        }
        
        
        
        
        
    }
    
   
    
    
    func ApiUpdateProfile()  {
        let dict = [
            "device_type" : "ios",
            "device_token" : DataManager.device_token ?? "text",
            "id" : Constants.CurrentUserData.id,
            ] as [String : Any]
        APIClients.UpdateProfile(parems: dict ,imageKey : [""] , image: [] , storyBoard: storyboard!, navigation: self) { (result) in
            switch result {
            case .success(let userResult):
                Constants.Toast.MyToast(message: userResult.message ?? "" , image: Constants.AppLogo)
                DataManager.CurrentUserData = userResult.user
                Constants.CurrentUserData = DataManager.CurrentUserData
                NotificationCenter.default.post(name: NSNotification.Name.init("NotificationUpdateAmount"), object: [:])
            case .failure( _):
                print("Fail")
            }
        } failure: { (Result) in
            print(Result)
        } progressUpload: { (Result) in
            print(Result)
            
        }

    }

    
    
    func AddLoader(_ loader : Bool = true , navigation : UIViewController) -> UIView  {
        let view = UIView.init(frame: UIWindow.init().screen.bounds)
        view.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.3674015411)

            let activityIndicatorView =  NVActivityIndicatorView(frame: navigation.view.frame, type: .ballScale, color: Constants.AppColor)
            activityIndicatorView.frame = CGRect.init(x: view.frame.size.width/2 - 50, y: view.frame.size.height/2 - 50, width: 100, height: 100)
            view.addSubview(activityIndicatorView)
            if loader{
                activityIndicatorView.startAnimating()
                let clientApp = UIApplication.shared

                let windows = clientApp.windows
                var topWindow : UIWindow? = nil
                if windows.count != 0{
                    topWindow = windows[0]
                }
                topWindow?.addSubview(view)
            }
            return view
        
    }
    
    func EndLoader(_ loader : Bool = true)  {
        if loader{
            let av = NVActivityIndicatorView(frame: self.view.frame, type: .ballBeat, color: #colorLiteral(red: 0.7900810838, green: 0.6154652238, blue: 0, alpha: 1))
            av.stopAnimating()
        }
    }
    func dismiss(animated : Bool = true) {
        dismiss(animated: animated, completion: nil)
    }
    func ResignAllText()  {
        IQKeyboardManager.shared.resignFirstResponder()
    }

    
}
extension UITableView{
    func RegisterTableCell(_ Identifier : String)  {
        
        self.register(UINib.init(nibName: Identifier, bundle: nil), forCellReuseIdentifier: Identifier)
        self.tableFooterView = UIView()
    }
}
extension UICollectionView{
    func RegisterTableCell(_ Identifier : String)  {
        
        self.register(UINib.init(nibName: Identifier, bundle: nil), forCellWithReuseIdentifier: Identifier)
    }
}

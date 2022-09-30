//
//  DataModel.swift
//  BnkUp
//
//  Created by OSX on 04/10/16.
//  Copyright © 2016 Jaipreet. All rights reserved.
//

import Alamofire
import UIKit
import IQKeyboardManagerSwift
import NVActivityIndicatorView
import SafariServices


enum Result<Value> {
    case success(Value)
    case failure(String)
}
extension String {
    public func getDomain() -> String? {
        guard let url = URL(string: self) else { return nil }
        return url.host
    }
}
class DataModelCode : NSObject {
    
    
    class Connectivity {
        class var isConnectedToInternet:Bool {
            return NetworkReachabilityManager()?.isReachable ?? false
        }
    }

    
    
    func GetApi<T: Decodable>(Url: String, method : HTTPMethod , params : [String : Any] = ["":""] ,headers : HTTPHeaders  , loader : Bool = true , alert : Bool = true , keyboard : Bool = true , storyBoard : UIStoryboard , navigation : UIViewController , Completion: @escaping (_ result:(Result<T>) )   -> Void , failure: @escaping (_ result:(Result<String>) ) -> Void )  {
        if CheckInternet() {return}

      let av = SetupApiEnviernment(loader: loader, keyboard: loader, navigation: navigation)

        let startDate = Date()

        var url = "\(Url)"
            url = url.replacingOccurrences(of: " ", with: "%20")
            print(url)
            print(params)
            print(headers)
        

  
        AF.request(url, method: method, parameters: params ,encoding: URLEncoding.default , headers: headers ).responseData { (response) in
            av.removeFromSuperview()
            navigation.EndLoader(loader)
            guard response.error == nil else {
                print(response.error)
                Constants.Toast.MyToast(message: TextStrings.MESSAGE.SOMETHING_Wrong , image: #imageLiteral(resourceName: "exclamationCircle") , show : alert)

                return  failure(.failure(TextStrings.MESSAGE.SOMETHING_Wrong) )
            }
            guard let responseData = response.data else {
                Constants.Toast.MyToast(message: TextStrings.MESSAGE.SOMETHING_Wrong , image: #imageLiteral(resourceName: "exclamationCircle") , show : alert)
                return failure(.failure(TextStrings.MESSAGE.SOMETHING_Wrong) )
            }
            switch (response.response?.statusCode)! {
                case 200...299:
                    let executionTimeWithSuccess = Date().timeIntervalSince(startDate)
                    print("Url=\(url), Time=\(executionTimeWithSuccess)")
                    do {
                        let item = try JSONDecoder().decode(T.self, from: responseData)
                        print(item)
                        
                        Completion(.success(item))
                    } catch {
                        do {
                            let json = try JSONSerialization.jsonObject(with: responseData, options: []) as! [String : Any]
                            print(json)

                            failure(.failure(TextStrings.MESSAGE.SOMETHING_Wrong) )
                            if alert{
                                Constants.Toast.MyToast(message: TextStrings.MESSAGE.NO_EVENT_FOUND , image: Constants.AppLogo,show : alert)
                            }
                            } catch {
                                failure(.failure(TextStrings.MESSAGE.SOMETHING_Wrong) )
                                if alert{
                                   Constants.Toast.MyToast(message: TextStrings.MESSAGE.SOMETHING_Wrong , image: #imageLiteral(resourceName: "exclamationCircle"),show : alert)
                                }
                            }
                    }
                return
                case 500 , 405 , 404:
                    do {
                        let json = try JSONSerialization.jsonObject(with: responseData, options: []) as! [String : Any]
                        var Message : String = ""
                        if json["error"] is String{
                            Message = json["error"] as! String
                        }
                        if json["message"] is String{
                            Message = json["message"] as! String
                        }
                        print(json)
                        failure(.failure(Message) )
                            Constants.Toast.MyToast(message: Message , image: #imageLiteral(resourceName: "exclamationCircle"), show:  alert)
                        } catch {
                            failure(.failure(TextStrings.MESSAGE.SOMETHING_Wrong) )
                            Constants.Toast.MyToast(message: TextStrings.MESSAGE.SOMETHING_Wrong , image: #imageLiteral(resourceName: "exclamationCircle"),show : alert)
                        }
                return
                case 401:
                
                    do {
                        let json = try JSONSerialization.jsonObject(with: responseData, options: []) as! [String : Any]
                        var Message : String = ""
                        if json["error"] is String{
                            Message = json["error"] as! String
                        }
                        if json["message"] is String{
                            Message = json["message"] as! String
                        }
                    
                  
                            Constants.Toast.MyToast(message: Message , image: Constants.AppLogo,show : loader)

                            DataManager.CurrentUserData = nil
//                        let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "WelcomeViewController") as! WelcomeViewController
//                            vc.modalPresentationStyle = .fullScreen
//
//                            let when = DispatchTime.now() + 1.8
//                                            DispatchQueue.main.asyncAfter(deadline: when)
//                                            {
//                                                navigation.present(vc, animated: false, completion: nil)
//                                            }
                        

                        
                            failure(.failure(TextStrings.MESSAGE.SOMETHING_Wrong) )


                    } catch {
                        failure(.failure(TextStrings.MESSAGE.Logged_Out_Login_Again) )
                        Constants.Toast.MyToast(message: TextStrings.MESSAGE.Logged_Out_Login_Again , image: Constants.AppLogo,show : alert)
                    }
                 
                    return
                default:
                    failure(.failure(TextStrings.MESSAGE.SOMETHING_Wrong) )
                    Constants.Toast.MyToast(message: TextStrings.MESSAGE.SOMETHING_Wrong , image: #imageLiteral(resourceName: "exclamationCircle"),show : loader)
                    return
            }
        }
    }
    
    func GetWithoutStoryboard<T: Decodable>(Url: String, method : HTTPMethod , params : [String : Any] = ["":""] ,headers : HTTPHeaders   , Completion: @escaping (_ result:(Result<T>) )   -> Void , failure: @escaping (_ result:(Result<String>) ) -> Void )  {
        if CheckInternet() {return}


        let startDate = Date()

        var url = "\(Url)"
            url = url.replacingOccurrences(of: " ", with: "%20")
            print(url)
            print(params)
            print(headers)
        

  
        AF.request(url, method: method, parameters: params ,encoding: URLEncoding.default , headers: headers ).responseData { (response) in
            guard response.error == nil else {
                print(response.error)
                Constants.Toast.MyToast(message: TextStrings.MESSAGE.SOMETHING_Wrong , image: #imageLiteral(resourceName: "exclamationCircle") , show : true)

                return  failure(.failure(TextStrings.MESSAGE.SOMETHING_Wrong) )
            }
            guard let responseData = response.data else {
                Constants.Toast.MyToast(message: TextStrings.MESSAGE.SOMETHING_Wrong , image: #imageLiteral(resourceName: "exclamationCircle") , show : true)
                return failure(.failure(TextStrings.MESSAGE.SOMETHING_Wrong) )
            }
            switch (response.response?.statusCode)! {
                case 200...299:
                    let executionTimeWithSuccess = Date().timeIntervalSince(startDate)
                    print("Url=\(url), Time=\(executionTimeWithSuccess)")
                    do {
                        let item = try JSONDecoder().decode(T.self, from: responseData)
                        print(item)
                        
                        Completion(.success(item))
                    } catch {
                        do {
                            let json = try JSONSerialization.jsonObject(with: responseData, options: []) as! [String : Any]
                            print(json)

                            failure(.failure(TextStrings.MESSAGE.SOMETHING_Wrong) )
                                Constants.Toast.MyToast(message: TextStrings.MESSAGE.NO_EVENT_FOUND , image: Constants.AppLogo,show : true)
                            
                            } catch {
                                failure(.failure(TextStrings.MESSAGE.SOMETHING_Wrong) )
                                   Constants.Toast.MyToast(message: TextStrings.MESSAGE.SOMETHING_Wrong , image: #imageLiteral(resourceName: "exclamationCircle"),show : true)
                                
                            }
                    }
                return
                case 500 , 405 , 404:
                    do {
                        let json = try JSONSerialization.jsonObject(with: responseData, options: []) as! [String : Any]
                        var Message : String = ""
                        if json["error"] is String{
                            Message = json["error"] as! String
                        }
                        if json["message"] is String{
                            Message = json["message"] as! String
                        }
                        print(json)
                        failure(.failure(Message) )
                            Constants.Toast.MyToast(message: Message , image: #imageLiteral(resourceName: "exclamationCircle"), show:  true)
                        } catch {
                            failure(.failure(TextStrings.MESSAGE.SOMETHING_Wrong) )
                            Constants.Toast.MyToast(message: TextStrings.MESSAGE.SOMETHING_Wrong , image: #imageLiteral(resourceName: "exclamationCircle"),show : true)
                        }
                return
                case 401:
                
                    do {
                        let json = try JSONSerialization.jsonObject(with: responseData, options: []) as! [String : Any]
                        var Message : String = ""
                        if json["error"] is String{
                            Message = json["error"] as! String
                        }
                        if json["message"] is String{
                            Message = json["message"] as! String
                        }
                    
                  
                            Constants.Toast.MyToast(message: Message , image: Constants.AppLogo,show : true)

                            DataManager.CurrentUserData = nil
//                        let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "WelcomeViewController") as! WelcomeViewController
//                            vc.modalPresentationStyle = .fullScreen
//
//                            let when = DispatchTime.now() + 1.8
//                                            DispatchQueue.main.asyncAfter(deadline: when)
//                                            {
//                                                navigation.present(vc, animated: false, completion: nil)
//                                            }
                        

                        
                            failure(.failure(TextStrings.MESSAGE.SOMETHING_Wrong) )


                    } catch {
                        failure(.failure(TextStrings.MESSAGE.Logged_Out_Login_Again) )
                        Constants.Toast.MyToast(message: TextStrings.MESSAGE.Logged_Out_Login_Again , image: Constants.AppLogo,show : true)
                    }
                 
                    return
                default:
                    failure(.failure(TextStrings.MESSAGE.SOMETHING_Wrong) )
                    Constants.Toast.MyToast(message: TextStrings.MESSAGE.SOMETHING_Wrong , image: #imageLiteral(resourceName: "exclamationCircle"),show : true)
                    return
            }
        }
    }

    
  func GetApiJson(Url: String, method : HTTPMethod , params : [String : Any] = ["":""] ,headers : HTTPHeaders  , loader : Bool = true , alert : Bool = true , keyboard : Bool = true , storyBoard : UIStoryboard , navigation : UIViewController, withCompletionHandler:@escaping (_ result:NSDictionary , _ Error : NSString , _ StatusCode : Int ) -> Void)  {
          if CheckInternet() {return}

//        let av = SetupApiEnviernment(loader: loader, keyboard: loader, navigation: navigation)


          var url = "\(Url)"
              url = url.replacingOccurrences(of: " ", with: "%20")
              print(url)
              print(params)
  //            print(headers)
    AF.request(url, method: .get).responseJSON { response in
        // server data
//        av.removeFromSuperview()
        navigation.EndLoader(loader)
     
            if let JSON = response.value {
            print("JSON: \(JSON)")
            if JSON is NSDictionary{
                
        
                if response.response?.statusCode != 200 {
                    if alert{
                        withCompletionHandler( JSON as! NSDictionary , TextStrings.API_ERROR_TYPE.API_CRASH as NSString, (response.response?.statusCode)!)
                    }
                }
                withCompletionHandler( JSON as! NSDictionary , TextStrings.API_ERROR_TYPE.Success as NSString, (response.response?.statusCode)!)
            }
            else{
                let JSON = ["error":"data"]
                withCompletionHandler( JSON as NSDictionary , TextStrings.API_ERROR_TYPE.API_CRASH as NSString , (response.response?.statusCode)! )
                if alert{
                    Constants.Toast.MyToast(message: TextStrings.MESSAGE.SOMETHING_Wrong, image:#imageLiteral(resourceName: "exclamationCircle"))
                }
            }
        }
        else{
            var type : String = TextStrings.API_ERROR_TYPE.API_CRASH
            var message : String = TextStrings.API_ERROR_TYPE.API_CRASH
            
            if response.error?.localizedDescription  == "The network connection was lost."{
                type = TextStrings.API_ERROR_TYPE.RE_Hit
                
            }
            else if response.error?.localizedDescription  == "The Internet connection appears to be offline."{
                type = TextStrings.API_ERROR_TYPE.NO_NETWORK
                
                message =  TextStrings.MESSAGE.INTERNET_LOST
                
            }
            else{
                message =  TextStrings.MESSAGE.SOMETHING_Wrong
                
            }
            if alert && type != TextStrings.API_ERROR_TYPE.RE_Hit{
                Constants.Toast.MyToast(message: message, image: Constants.AppLogo)
            }
            let JSON = ["error":response.error?.localizedDescription , "type" : type]
            if  type != TextStrings.API_ERROR_TYPE.RE_Hit{
                
                withCompletionHandler( JSON as NSDictionary , type as NSString , 111 )
            }
        }
    }
          
    
}
   
    
    func GetApidata(Url: String, withCompletionHandler:@escaping (_ data:NSData , _ Error : NSString , _ StatusCode : Int ) -> Void)  {
            if CheckInternet() {return}



            var url = "\(Url)"
                url = url.replacingOccurrences(of: " ", with: "%20")
                print(url)
    //            print(headers)
      AF.request(url, method: .get).responseData { response in
          // server data
       
              if let JSON = response.value {
              print("JSON: \(JSON)")
                  
        
                  if response.response?.statusCode == 200 {
                        withCompletionHandler( JSON as NSData , TextStrings.API_ERROR_TYPE.Success as NSString, (response.response?.statusCode)!)
                  }
                
              
          }
          
      }
            
      
  }
    
    
    
    
    func UploadDataWithTokenMultipleImageData<T: Decodable>(
        Url: String,
        method : HTTPMethod ,
        params : [String : Any] = ["":""] ,
        headers : HTTPHeaders ,
        OtherMedia : [URL] = [],
        OtherData : [Data] = [],
        OtherDataKey : [String] = [] ,

//4219
        image : [UIImage] = [],
        imageKey : [String]  ,
        loader : Bool = true ,
        alert : Bool = true ,
        keyboard : Bool = true ,
        storyBoard : UIStoryboard ,
        navigation : UIViewController ,
         Completion: @escaping (_ result:(Result<T>) )   -> Void ,
         failure: @escaping (_ result:(Result<String>) ) -> Void ,
        progressUpload: @escaping (_ result:(Int) ) -> Void )  {
            if CheckInternet() {return}
//            navigation.AddLoader(loader)
            print(params)
            let av = SetupApiEnviernment(loader: loader, keyboard: loader, navigation: navigation)
        let  uploadTaskID = UIApplication.shared.beginBackgroundTask(expirationHandler: {})
        
        AF.upload(multipartFormData: { multipartFormData in
            
            for  (key, value) in params{
                print("*******  \(key) : \(value)")
                if value is String{
                    multipartFormData.append((value as! String).data(using: String.Encoding.utf8)!, withName: key )
                }
                else{
                    multipartFormData.append(("\(value)").data(using: String.Encoding.utf8)!, withName: key )

                }
                
                //print("******* value = \(value)")
            }
            for  (key, _) in OtherMedia.enumerated(){
                    multipartFormData.append(OtherMedia[key], withName: imageKey[key], fileName: "\(imageKey[key])/\(Int(NSDate().timeIntervalSince1970)).MOV", mimeType: "MOV")

                    print("\(imageKey[key])/\(Int(NSDate().timeIntervalSince1970)).MOV")


            }
            for  (key, _) in OtherData.enumerated(){
                    multipartFormData.append(OtherData[key], withName: OtherDataKey[key])

                    print("\(imageKey[key])")


            }
            
            for  (key, _) in image.enumerated(){
                multipartFormData.append(image[key].jpegData(compressionQuality: 0.4)! , withName: imageKey[key], fileName: "\(imageKey[key])/\(Int(NSDate().timeIntervalSince1970)).jpeg", mimeType: "image/jpeg")
                print("\(imageKey[key])/\(Int(NSDate().timeIntervalSince1970)).jpeg")
            }
        },


        to: CheckURL(Url: Url),
//        usingThreshold: UInt64.init(),
           method:.post,
        headers:headers ).responseData { (response) in
            av.removeFromSuperview()
            navigation.EndLoader(loader)
            guard response.error == nil else {
                print(response.error)
                Constants.Toast.MyToast(message: TextStrings.MESSAGE.SOMETHING_Wrong , image: #imageLiteral(resourceName: "exclamationCircle") , show : alert)

                return  failure(.failure(TextStrings.MESSAGE.SOMETHING_Wrong) )
            }
            guard let responseData = response.data else {
                Constants.Toast.MyToast(message: TextStrings.MESSAGE.SOMETHING_Wrong , image: #imageLiteral(resourceName: "exclamationCircle") , show : alert)
                return failure(.failure(TextStrings.MESSAGE.SOMETHING_Wrong) )
            }
            switch (response.response?.statusCode)! {
                case 200...299:
                    
                    do {
                        let item = try JSONDecoder().decode(T.self, from: responseData)
                        print(item)
                        
                        Completion(.success(item))
                    } catch {
                        do {
                            let json = try JSONSerialization.jsonObject(with: responseData, options: []) as! [String : Any]
                            print(json)

                            failure(.failure(TextStrings.MESSAGE.SOMETHING_Wrong) )
                            if alert{
                                Constants.Toast.MyToast(message: TextStrings.MESSAGE.NO_EVENT_FOUND , image: Constants.AppLogo,show : alert)
                            }
                            } catch {
                                failure(.failure(TextStrings.MESSAGE.SOMETHING_Wrong) )
                                if alert{
                                   Constants.Toast.MyToast(message: TextStrings.MESSAGE.SOMETHING_Wrong , image: #imageLiteral(resourceName: "exclamationCircle"),show : alert)
                                }
                            }
                    }
                return
                case 500 , 405 , 404:
                    do {
                        let json = try JSONSerialization.jsonObject(with: responseData, options: []) as! [String : Any]
                        var Message : String = ""
                        if json["error"] is String{
                            Message = json["error"] as! String
                        }
                        if json["message"] is String{
                            Message = json["message"] as! String
                        }
                        print(json)
                        failure(.failure(Message) )
                            Constants.Toast.MyToast(message: Message , image: #imageLiteral(resourceName: "exclamationCircle"), show:  alert)
                        } catch {
                            failure(.failure(TextStrings.MESSAGE.SOMETHING_Wrong) )
                            Constants.Toast.MyToast(message: TextStrings.MESSAGE.SOMETHING_Wrong , image: #imageLiteral(resourceName: "exclamationCircle"),show : alert)
                        }
                return
                case 401:
                
                    do {
                        let json = try JSONSerialization.jsonObject(with: responseData, options: []) as! [String : Any]
                        var Message : String = ""
                        if json["error"] is String{
                            Message = json["error"] as! String
                        }
                        if json["message"] is String{
                            Message = json["message"] as! String
                        }
                    
                  
                            Constants.Toast.MyToast(message: Message , image: Constants.AppLogo,show : loader)

                            DataManager.CurrentUserData = nil
//                        let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "WelcomeViewController") as! WelcomeViewController
//                            vc.modalPresentationStyle = .fullScreen
//
//                            let when = DispatchTime.now() + 1.8
//                                            DispatchQueue.main.asyncAfter(deadline: when)
//                                            {
//                                                navigation.present(vc, animated: false, completion: nil)
//                                            }
                        

                        
                            failure(.failure(TextStrings.MESSAGE.SOMETHING_Wrong) )


                    } catch {
                        failure(.failure(TextStrings.MESSAGE.Logged_Out_Login_Again) )
                        Constants.Toast.MyToast(message: TextStrings.MESSAGE.Logged_Out_Login_Again , image: Constants.AppLogo,show : alert)
                    }
                 
                    return
                default:
                    failure(.failure(TextStrings.MESSAGE.SOMETHING_Wrong) )
                    Constants.Toast.MyToast(message: TextStrings.MESSAGE.SOMETHING_Wrong , image: #imageLiteral(resourceName: "exclamationCircle"),show : loader)
                    return
            }
        }
            
            
            

        
        
           
    }

    
    


    
    
    func CheckInternet() -> Bool {
           if !Connectivity.isConnectedToInternet {
               Constants.Toast.MyToast(message: TextStrings.MESSAGE.INTERNET_LOST , image: Constants.AppLogo)
               print("no! internet is not available.")
               return true
           }
           else{
               return false
           }
       }
    
     func CheckURL(Url : String) -> String {
         var url = "\(Url)"
         url = url.replacingOccurrences(of: " ", with: "%20")
         print(url)
         return url
     }
    func SetupApiEnviernment(loader : Bool  , keyboard : Bool ,navigation : UIViewController) ->  UIView{
          if keyboard{
              IQKeyboardManager.shared.resignFirstResponder()
          }
        
        let view = UIView.init(frame: UIWindow.init().screen.bounds)
        view.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.3674015411)
        let activityIndicatorView =  NVActivityIndicatorView(frame: navigation.view.frame, type: .ballSpinFadeLoader, color: #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0))
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
      
 
}
 





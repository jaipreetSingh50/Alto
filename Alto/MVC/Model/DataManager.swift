//
//  DataManager.swift
//  EatDigger
//
//  Created by Ramneet Singh on 02/05/18.
//  Copyright © 2018 Ramneet Singh. All rights reserved.
//

import Foundation

class DataManager: NSObject {

    static var CurrentUserRole:String? {
        set {
            UserDefaults.standard.setValue(newValue, forKey: "CurrentUserRole")
            UserDefaults.standard.synchronize()
        }
        get {
            if UserDefaults.standard.string(forKey: "CurrentUserRole") != nil{
                return UserDefaults.standard.string(forKey: "CurrentUserRole")
            }
            return "1"
        }
    }
    static var CurrentAppLanguage:String? {
        set {
            UserDefaults.standard.setValue(newValue, forKey: "CurrentAppLanguage")
            UserDefaults.standard.synchronize()
        }
        get {
            if UserDefaults.standard.string(forKey: "CurrentAppLanguage") != nil{
                return UserDefaults.standard.string(forKey: "CurrentAppLanguage")
            }
            return "en"
        }
    }

    static var CurrentAppLanguageString:String? {
        set {
            UserDefaults.standard.setValue(newValue, forKey: "CurrentAppLanguageString")
            UserDefaults.standard.synchronize()
        }
        get {
            if UserDefaults.standard.string(forKey: "CurrentAppLanguageString") != nil{
                return UserDefaults.standard.string(forKey: "CurrentAppLanguageString")
            }
            return "en"
        }
    }
    static var CurrentAppLanguageImage:String? {
        set {
            UserDefaults.standard.setValue(newValue, forKey: "CurrentAppLanguageimage")
            UserDefaults.standard.synchronize()
        }
        get {
            if UserDefaults.standard.string(forKey: "CurrentAppLanguageimage") != nil{
                return UserDefaults.standard.string(forKey: "CurrentAppLanguageimage")
            }
            return "en"
        }
    }
    static var AppCurrentVersion:String? {
        set {
            UserDefaults.standard.setValue(newValue, forKey: "AppCurrentVersion")
            UserDefaults.standard.synchronize()
        }
        get {
            if UserDefaults.standard.string(forKey: "AppCurrentVersion") != nil{
                return UserDefaults.standard.string(forKey: "AppCurrentVersion")
            }
            return ""
        }
    }

    static var AppLaunchAgain:Bool? {
        set {
            UserDefaults.standard.setValue(newValue, forKey: "AppLaunchAgain")
            UserDefaults.standard.synchronize()
        }
        get {
            if UserDefaults.standard.bool(forKey: "AppLaunchAgain") != nil{
                return UserDefaults.standard.bool(forKey: "AppLaunchAgain")
            }
            return false
        }
    }
    
    static var AppFirstLaunch:Bool? {
        set {
            UserDefaults.standard.setValue(newValue, forKey: "AppFirstLaunch")
            UserDefaults.standard.synchronize()
        }
        get {
            if UserDefaults.standard.bool(forKey: "AppFirstLaunch") != nil{
                return UserDefaults.standard.bool(forKey: "AppFirstLaunch")
            }
            return false
        }
    }

    static var SeniorRememberEmail:String? {
        set {
            UserDefaults.standard.setValue(newValue, forKey: "SeniorRememberEmail")
            UserDefaults.standard.synchronize()
        }
        get {
            if UserDefaults.standard.string(forKey: "SeniorRememberEmail") != nil{
                return UserDefaults.standard.string(forKey: "SeniorRememberEmail")
            }
            return ""
        }
    }
    static var SeniorRememberPassword:String? {
        set {
            UserDefaults.standard.setValue(newValue, forKey: "SeniorRememberPassword")
            UserDefaults.standard.synchronize()
        }
        get {
            if UserDefaults.standard.string(forKey: "SeniorRememberPassword") != nil{
                return UserDefaults.standard.string(forKey: "SeniorRememberPassword")
            }
            return ""
        }
    }
    static var CompanionRememberEmail:String? {
        set {
            UserDefaults.standard.setValue(newValue, forKey: "CompanionRememberEmail")
            UserDefaults.standard.synchronize()
        }
        get {
            if UserDefaults.standard.string(forKey: "CompanionRememberEmail") != nil{
                return UserDefaults.standard.string(forKey: "CompanionRememberEmail")
            }
            return ""
        }
    }
    static var CompanionRememberPassword:String? {
        set {
            UserDefaults.standard.setValue(newValue, forKey: "CompanionRememberPassword")
            UserDefaults.standard.synchronize()
        }
        get {
            if UserDefaults.standard.string(forKey: "CompanionRememberPassword") != nil{
                return UserDefaults.standard.string(forKey: "CompanionRememberPassword")
            }
            return ""
        }
    }
    
    
    static var device_token:String? {
        set {
            UserDefaults.standard.setValue(newValue, forKey: "device_token")
            UserDefaults.standard.synchronize()
        }
        get {
            if UserDefaults.standard.string(forKey: "device_token") != nil{
                return UserDefaults.standard.string(forKey: "device_token")
            }
            return "test"
        }
    }
    static var Push_device_token:String? {
        set {
            UserDefaults.standard.setValue(newValue, forKey: "Push_device_token")
            UserDefaults.standard.synchronize()
        }
        get {
            if UserDefaults.standard.string(forKey: "Push_device_token") != nil{
                return UserDefaults.standard.string(forKey: "Push_device_token")
            }
            return "test"
        }
    }
    static var device_token_Fcm:String? {
        set {
            UserDefaults.standard.setValue(newValue, forKey: "device_token_Fcm")
            UserDefaults.standard.synchronize()
        }
        get {
            if UserDefaults.standard.string(forKey: "device_token_Fcm") != nil{
                return UserDefaults.standard.string(forKey: "device_token_Fcm")
            }
            return "test"
        }
    }
    
    static var Auth_Token:String? {
        set {
            UserDefaults.standard.setValue(newValue, forKey: "Auth_Token")
            UserDefaults.standard.synchronize()
        }
        get {
            if UserDefaults.standard.string(forKey: "Auth_Token") != nil{
                return UserDefaults.standard.string(forKey: "Auth_Token")
            }
            return ""
        }
    }
    static var CurrentUserData:User? {
        set {
               if let newValue = newValue {
                    do {
                        let data = try JSONEncoder().encode(newValue)
                        UserDefaults.standard.set(data, forKey: "CurrentUserData")
                    } catch {
                        print("Error while encoding user data")
                    }
                } else {
                    UserDefaults.standard.removeObject(forKey: "CurrentUserData")
                }
            UserDefaults.standard.synchronize()
        }
        get {
          if let data = UserDefaults.standard.object(forKey: "CurrentUserData") as? Data {
                do {
                    return try JSONDecoder().decode(User.self, from: data)
                    } catch {
                        print("Error while decoding user data")
                    }
                }
            return nil
        }
    }


    


}

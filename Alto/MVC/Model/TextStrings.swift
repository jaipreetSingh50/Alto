//
//  String.swift
//  BringDat Mobile
//
//  Created by Jaypreet on 16/04/19.
//  Copyright © 2019 Jaypreet. All rights reserved.
//

import Foundation

struct TextStrings {
    
  

    
   
    struct API_ERROR_TYPE {
        static let API_CRASH =  "Error"
        static let NO_NETWORK =  "No Network"
        static let RE_Hit =  "Re hit"
        static let Success =  "Success"
     }
    struct BUTTON {

        static let CANCEL =  "Cancel"

        static let Submit =  "SUBMIT"
        static let Setting =  "Setting"
        static let Login =  "Login"
        static let OK =  "Ok"
        static let Alert =  "Alert"
    }
    struct MESSAGE {
        // Common message
        static let Logged_Out_Login_Again  = "You are currently logged out, please login again".SetLang()
        static let SOMETHING_Wrong  = "Something went wrong. Please try again.".SetLang()
        static let INTERNET_LOST  = "The Internet connection appears to be offline. Please check your Internet connection.".SetLang()
        static let LocationRequired =  "We need your location permission to send your location, please enable from your phone settings"

        static let NO_EVENT_FOUND  = "No Data found".SetLang()
        static let Invalid_password =  "Invalid password".SetLang()
        // Common Alert
        static let INVALID_EMAIL =  "Please provide a valid email address.".SetLang()
        static let EMPTY_Detail = "Please enter detail.".SetLang()
        static let EMPTY_Email =  "Please provide a valid email address".SetLang()
        static let EMPTY_Phone =  "Please provide phone number".SetLang()
        static let EMPTY_CountryCode =  "Please provide country code".SetLang()

        static let EMPTY_Password =  "Your password should be at least 8 carcaters, 1 capital letter, 1 numbers, 1 special sign %$*, etc.".SetLang()
        static let FACEBOOK_NOT_ABLE_TO_LOGIN = "We encountered a problem. Please try again".SetLang()
        static let EMPTY_Password_match =  "Passwords do not match".SetLang()
        static let CheckTermAndConditon =  "Please Read and Accept Terms & Conditions & Privacy Agreements".SetLang()
        static let CheckConsentAgreement =  "Please Read & Accept Consent Agreement".SetLang()
        static let CommonTextfieldMethod =  "Please ".SetLang()
    }
}


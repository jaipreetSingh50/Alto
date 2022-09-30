//
//  Constants.swift
//  FavBites
//
//  Created by jatin-pc on 8/30/17.
//  Copyright © 2017 Orem. All rights reserved.
//

import Foundation
import UIKit

enum Config {
    static let screenSize = UIScreen.main.bounds
    static let kAppDelegate = UIApplication.shared.delegate as! AppDelegate
    static let googleMapKey = "AIzaSyDM6e1w0fFfBoXTC994G86vsqxMECXKnx8"
    static let googleClientID = "993484998902-h8i8i0pq1isk7s1gn2spauv8obcvs710.apps.googleusercontent.com"

    // Replace with your OpenTok API key
    static var kApiKey = "47431751"
    // Replace with your generated session ID
    static var kSessionId = "2_MX40NzQzMTc1MX5-MTY0MzExODg1MjU2Nn5hQVJ3RkZzZ0VxV0tJMFpvUlZJYjZNRmJ-fg"
    // Replace with your generated token
    static var kToken = "T1==cGFydG5lcl9pZD00NzQzMTc1MSZzaWc9ZmZjMGU4MmYzZWVkZGQ0OWQxNGI5Y2NlODI1NDE2MmQ0NjM3MDk4YTpzZXNzaW9uX2lkPTJfTVg0ME56UXpNVGMxTVg1LU1UWTBNekV4T0RnMU1qVTJObjVoUVZKM1JrWnpaMFZ4VjB0Sk1GcHZVbFpKWWpaTlJtSi1mZyZjcmVhdGVfdGltZT0xNjQzMTE4ODUyJnJvbGU9cHVibGlzaGVyJm5vbmNlPTE2NDMxMTg4NTIuNzQ3OTkzMTE0MTUwNCZjb25uZWN0aW9uX2RhdGE9U29tZStzYW1wbGUrbWV0YWRhdGErdG8rcGFzcyZpbml0aWFsX2xheW91dF9jbGFzc19saXN0PQ=="
    //
}
class CommonInfoData {
    
    static let sharedInstance = CommonInfoData()
    private init(){}
}


struct SystemFont {
    static let FontFamilyName = "FIRASANS-REGULAR_0"
    static let FontFamilyNameBold = "FIRASANS-BOLD_0"
    static let FontFamilyNameSemiBold = "FIRASANS-SEMIBOLD_0"

    static let FontFamilyNameMedium = "FIRASANS-MEDIUM_0"
    static let FontFamilyNameLight = "FIRASANS-LIGHT_0"
}

enum UserRole  {
    
    case Senior
    case Companion

    
    func get() -> String{
        
        switch self {
            
        case .Senior : return "1"
        case .Companion : return "2"

            
        }
    }
}

let AppLanguagesArray = ["English", "French", "Italian" , "German" ]

enum AppLanguages  {
    
    case English
    case French
    case Italian
    case German
    
    func get() -> (String){
        
        switch self {
            
        case .English : return "1"
        case .French : return "2"
        case .Italian : return "3"
        case .German : return "4"
            
        }
    }
}
enum AppMeetingType  {
    
    case Online
    case FaceToFace
    func value() -> Int{
        
        switch self {
            
        case .Online : return 1
        case .FaceToFace : return 2

            
        }
    }

    
    func get() -> String{
        
        switch self {
            
        case .Online : return "Online"
        case .FaceToFace : return "Face To Face"

            
        }
    }
}

enum RequestStatus  {
    
    case New
    case Accepted
    case Rejected
    case Started
    case Completed
    case Confirmed
    case Paid

    case CancelledBySenior
    case CancelledByComapnion

    func get() -> Int{
        
        switch self {
            
        case .New : return 0
        case .Accepted : return 1
        case .Rejected : return -1
        case .Started : return 2
        case .Completed : return 3
        case .Confirmed : return 4
        case .Paid : return 5

        case .CancelledBySenior : return -2
        case .CancelledByComapnion : return -3

            
        }
    }
}



enum UserLoginType  {
    
    case Normal
    case Google
    case Apple

    
    func get() -> String{
        
        switch self {
            
        case .Normal : return "1"
        case .Google : return "2"
        case .Apple : return "3"

            
        }
    }
}



enum DateFormat  {
    
    case yyyy_MM_dd
    case yyyy_MMM_dd
    case dd_MMM_yyyy
    case MMM_dd_yyyy
    case MMM_dd
    case dd_MM_yyyy
    case hh_mm_a
    case HH_mm
    case hh_mm_ss_a
    case HH_mm_ss
    case yyyy_MM_dd_hh_mm_a
    case yyyy_MM_dd_hh_mm_a2
    case fullDataWithday
    
    func get() -> String{
        
        switch self {
            
        case .yyyy_MM_dd : return "yyyy-MM-dd"
        case .yyyy_MMM_dd : return "yyyy MMM dd"
        case .dd_MMM_yyyy : return "dd MMM yyyy"
        case .MMM_dd_yyyy : return "MMM dd yyyy"
        case .MMM_dd : return "MMM dd"
        case .dd_MM_yyyy : return "dd/MM/yyyy"
        case .hh_mm_a : return "hh:mm a"
        case .HH_mm : return "HH:mm"
        case .HH_mm_ss : return "HH:mm:ss"
        case .hh_mm_ss_a : return   "h:mm:ss a "
        case .yyyy_MM_dd_hh_mm_a : return "yyyy-MM-dd HH:mm:ss"
        case .yyyy_MM_dd_hh_mm_a2 : return "MMM dd yyyy, hh:mm a"
        case .fullDataWithday : return "E, d MMM yyyy, hh:mm a"
            
        }
    }
}


struct Constants {
    // Common Class
    static let Toast = AlertToast()
    static let timeFormat = TimeFormat()
    static let checkTextField = CheckTextField()
	static let userDefault = UserDefaults.standard
    static let Loader = ApiLoader()
    static let kAppDelegate = UIApplication.shared.delegate as! AppDelegate
    static let StrandredDateFormat = "yyyy-MM-dd HH:mm:ss ZZZZZ"
    static let StrandredDateFormatApi = "yyyy-MM-dd HH:mm:ss ZZZZZ"
	static var DeviceToken = DataManager.device_token
    static let DeviceType = "ios"
    static let AppName = "Alto"
    static let AppLogo : UIImage  = #imageLiteral(resourceName: "splash")
    static let AppColor : UIColor  = #colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1)
    static var UserRole = "1"
    static let CurrentLanguage = "1"
    static let ApiTimeOutTime = 3000
    static let TimeIntervalForSlot = 30 * 60
    static var ApiToken : String  = UserDefaults.standard.value(forKey: "LoginToken") as! String
    static var CurrentUserLat = ""
    static var CurrentUserLng = ""
    static var CurrentUserData : User!
    




    

    
    
    enum Language : String {
        case English = "1"
        case Arabic = "2"
    }

    struct API {
        
//        https://dev.appmantechnologies.com/alto/api/login
        static var Server_URL = "http://3.134.251.176"
//        static var Server_URL = "https://stopdiggingapp.co.nz"
        static var BASE_URL = Server_URL + "/api/"
        static var IMAGE_BASE_URL = Server_URL + "/public/storage/"
        static let POST_register : String = BASE_URL + "register"
        static let POST_social_login : String = BASE_URL + "social_login"

        static let POST_user_updateSeniorAddress : String = BASE_URL + "user/updateSeniorAddress"
        static let POST_user_addCard : String = BASE_URL + "user/addCard"
        static let POST_user_update_profile : String = BASE_URL + "user/update_profile"
        static let POST_login : String = BASE_URL + "login"
        static let POST_forgot_password : String = BASE_URL + "forgot_password"
        static let POST_Change_password : String = BASE_URL + "user/change_password"
        
        static let POST_user_updateCompanion : String = BASE_URL + "user/updateCompanion"
        static let POST_user_updateCompanion2 : String = BASE_URL + "user/updateCompanion2"
        static let POST_user_updateCompanion3 : String = BASE_URL + "user/updateCompanion3"
        static let POST_updateConnect : String = BASE_URL + "updateConnect?"
        static let POST_stripeKeyInfo : String = BASE_URL + "user/stripeKeyInfo"

        
        static let POST_country_list : String = BASE_URL + "country_list"
        static let POST_state_list : String = BASE_URL + "state_list"
        static let POST_city_list : String = BASE_URL + "city_list"
        static let POST_categories : String = BASE_URL + "categories"
        static let POST_user_nearbyCompanion : String = BASE_URL + "user/nearbyCompanion"
        static let POST_user_nearbySenior : String = BASE_URL + "user/nearbySenior"

        static let POST_user_companion_detail : String = BASE_URL + "user/companion_detail"
        static let POST_user_meetingStatusChange : String = BASE_URL + "user/meetingStatusChange"
        static let POST_user_meetingPaid : String = BASE_URL + "user/meetingPaid"

        static let POST_user_meetingDetail : String = BASE_URL + "user/meetingDetail"

        static let POST_user_userdeleteAddress : String = BASE_URL + "user/deleteAddress"

        
        static let POST_user_createRequest : String = BASE_URL + "user/createRequest"
        static let POST_user_meetingSeniorList : String = BASE_URL + "user/meetingSeniorList"
        static let POST_user_meetingCompanionList : String = BASE_URL + "user/meetingCompanionList"
        static let POST_user_addReview : String = BASE_URL + "user/addReview"
        static let POST_user_adminDetails : String = BASE_URL + "user/adminDetails"
        static let POST_user_notification_list : String = BASE_URL + "user/notification_list"
        static let POST_user_getReview : String = BASE_URL + "user/getReview"
        static let POST_user_opentok_session : String = BASE_URL + "user/opentok_session"
        static let POST_user_opentok_notification : String = BASE_URL + "user/opentok_notification"

//        https://dev.appmantechnologies.com/alto/api/user/opentok_session

        
        static let GET_Place_api =  "https://maps.googleapis.com/maps/api/place/nearbysearch/json"
        static let GET_LocationAddressApi =  "https://maps.googleapis.com/maps/api/place/findplacefromtext/json?"
    }

    

    static var countryDictionary  = ["AF":"93","AL":"355","DZ":"213","AS":"1","AD":"376","AO":"244",
                                     "AI":"1",
                                     "AG":"1",
                                     "AR":"54",
                                     "AM":"374",
                                     "AW":"297",
                                     "AU":"61",
                                     "AT":"43",
                                     "AZ":"994",
                                     "BS":"1",
                                     "BH":"973",
                                     "BD":"880",
                                     "BB":"1",
                                     "BY":"375",
                                     "BE":"32",
                                     "BZ":"501",
                                     "BJ":"229",
                                     "BM":"1",
                                     "BT":"975",
                                     "BA":"387",
                                     "BW":"267",
                                     "BR":"55",
                                     "IO":"246",
                                     "BG":"359",
                                     "BF":"226",
                                     "BI":"257",
                                     "KH":"855",
                                     "CM":"237",
                                     "CA":"1",
                                     "CV":"238",
                                     "KY":"345",
                                     "CF":"236",
                                     "TD":"235",
                                     "CL":"56",
                                     "CN":"86",
                                     "CX":"61",
                                     "CO":"57",
                                     "KM":"269",
                                     "CG":"242",
                                     "CK":"682",
                                     "CR":"506",
                                     "HR":"385",
                                     "CU":"53",
                                     "CY":"537",
                                     "CZ":"420",
                                     "DK":"45",
                                     "DJ":"253",
                                     "DM":"1",
                                     "DO":"1",
                                     "EC":"593",
                                     "EG":"20",
                                     "SV":"503",
                                     "GQ":"240",
                                     "ER":"291",
                                     "EE":"372",
                                     "ET":"251",
                                     "FO":"298",
                                     "FJ":"679",
                                     "FI":"358",
                                     "FR":"33",
                                     "GF":"594",
                                     "PF":"689",
                                     "GA":"241",
                                     "GM":"220",
                                     "GE":"995",
                                     "DE":"49",
                                     "GH":"233",
                                     "GI":"350",
                                     "GR":"30",
                                     "GL":"299",
                                     "GD":"1",
                                     "GP":"590",
                                     "GU":"1",
                                     "GT":"502",
                                     "GN":"224",
                                     "GW":"245",
                                     "GY":"595",
                                     "HT":"509",
                                     "HN":"504",
                                     "HU":"36",
                                     "IS":"354",
                                     "IN":"91",
                                     "ID":"62",
                                     "IQ":"964",
                                     "IE":"353",
                                     "IL":"972",
                                     "IT":"39",
                                     "JM":"1",
                                     "JP":"81",
                                     "JO":"962",
                                     "KZ":"77",
                                     "KE":"254",
                                     "KI":"686",
                                     "KW":"965",
                                     "KG":"996",
                                     "LV":"371",
                                     "LB":"961",
                                     "LS":"266",
                                     "LR":"231",
                                     "LI":"423",
                                     "LT":"370",
                                     "LU":"352",
                                     "MG":"261",
                                     "MW":"265",
                                     "MY":"60",
                                     "MV":"960",
                                     "ML":"223",
                                     "MT":"356",
                                     "MH":"692",
                                     "MQ":"596",
                                     "MR":"222",
                                     "MU":"230",
                                     "YT":"262",
                                     "MX":"52",
                                     "MC":"377",
                                     "MN":"976",
                                     "ME":"382",
                                     "MS":"1",
                                     "MA":"212",
                                     "MM":"95",
                                     "NA":"264",
                                     "NR":"674",
                                     "NP":"977",
                                     "NL":"31",
                                     "AN":"599",
                                     "NC":"687",
                                     "NZ":"64",
                                     "NI":"505",
                                     "NE":"227",
                                     "NG":"234",
                                     "NU":"683",
                                     "NF":"672",
                                     "MP":"1",
                                     "NO":"47",
                                     "OM":"968",
                                     "PK":"92",
                                     "PW":"680",
                                     "PA":"507",
                                     "PG":"675",
                                     "PY":"595",
                                     "PE":"51",
                                     "PH":"63",
                                     "PL":"48",
                                     "PT":"351",
                                     "PR":"1",
                                     "QA":"974",
                                     "RO":"40",
                                     "RW":"250",
                                     "WS":"685",
                                     "SM":"378",
                                     "SA":"966",
                                     "SN":"221",
                                     "RS":"381",
                                     "SC":"248",
                                     "SL":"232",
                                     "SG":"65",
                                     "SK":"421",
                                     "SI":"386",
                                     "SB":"677",
                                     "ZA":"27",
                                     "GS":"500",
                                     "ES":"34",
                                     "LK":"94",
                                     "SD":"249",
                                     "SR":"597",
                                     "SZ":"268",
                                     "SE":"46",
                                     "CH":"41",
                                     "TJ":"992",
                                     "TH":"66",
                                     "TG":"228",
                                     "TK":"690",
                                     "TO":"676",
                                     "TT":"1",
                                     "TN":"216",
                                     "TR":"90",
                                     "TM":"993",
                                     "TC":"1",
                                     "TV":"688",
                                     "UG":"256",
                                     "UA":"380",
                                     "AE":"971",
                                     "GB":"44",
                                     "US":"1",
                                     "UY":"598",
                                     "UZ":"998",
                                     "VU":"678",
                                     "WF":"681",
                                     "YE":"967",
                                     "ZM":"260",
                                     "ZW":"263",
                                     "BO":"591",
                                     "BN":"673",
                                     "CC":"61",
                                     "CD":"243",
                                     "CI":"225",
                                     "FK":"500",
                                     "GG":"44",
                                     "VA":"379",
                                     "HK":"852",
                                     "IR":"98",
                                     "IM":"44",
                                     "JE":"44",
                                     "KP":"850",
                                     "KR":"82",
                                     "LA":"856",
                                     "LY":"218",
                                     "MO":"853",
                                     "MK":"389",
                                     "FM":"691",
                                     "MD":"373",
                                     "MZ":"258",
                                     "PS":"970",
                                     "PN":"872",
                                     "RE":"262",
                                     "RU":"7",
                                     "BL":"590",
                                     "SH":"290",
                                     "KN":"1",
                                     "LC":"1",
                                     "MF":"590",
                                     "PM":"508",
                                     "VC":"1",
                                     "ST":"239",
                                     "SO":"252",
                                     "SJ":"47",
                                     "SY":"963",
                                     "TW":"886",
                                     "TZ":"255",
                                     "TL":"670",
                                     "VE":"58",
                                     "VN":"84",
                                     "VG":"284",
                                     "VI":"340"]  as NSDictionary
    
}
public extension UIDevice {
    
    static let modelName: String = {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        
        func mapToDevice(identifier: String) -> String { // swiftlint:disable:this cyclomatic_complexity
            #if os(iOS)
            switch identifier {
            case "iPod5,1":                                 return "iPod Touch 5"
            case "iPod7,1":                                 return "iPod Touch 6"
            case "iPhone3,1", "iPhone3,2", "iPhone3,3":     return "iPhone 4"
            case "iPhone4,1":                               return "iPhone 4s"
            case "iPhone5,1", "iPhone5,2":                  return "iPhone 5"
            case "iPhone5,3", "iPhone5,4":                  return "iPhone 5c"
            case "iPhone6,1", "iPhone6,2":                  return "iPhone 5s"
            case "iPhone7,2":                               return "iPhone 6"
            case "iPhone7,1":                               return "iPhone 6 Plus"
            case "iPhone8,1":                               return "iPhone 6s"
            case "iPhone8,2":                               return "iPhone 6s Plus"
            case "iPhone9,1", "iPhone9,3":                  return "iPhone 7"
            case "iPhone9,2", "iPhone9,4":                  return "iPhone 7 Plus"
            case "iPhone8,4":                               return "iPhone SE"
            case "iPhone10,1", "iPhone10,4":                return "iPhone 8"
            case "iPhone10,2", "iPhone10,5":                return "iPhone 8 Plus"
            case "iPhone10,3", "iPhone10,6":                return "iPhone X"
            case "iPhone11,2":                              return "iPhone XS"
            case "iPhone11,4", "iPhone11,6":                return "iPhone XS Max"
            case "iPhone11,8":                              return "iPhone XR"
            case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":return "iPad 2"
            case "iPad3,1", "iPad3,2", "iPad3,3":           return "iPad 3"
            case "iPad3,4", "iPad3,5", "iPad3,6":           return "iPad 4"
            case "iPad4,1", "iPad4,2", "iPad4,3":           return "iPad Air"
            case "iPad5,3", "iPad5,4":                      return "iPad Air 2"
            case "iPad6,11", "iPad6,12":                    return "iPad 5"
            case "iPad7,5", "iPad7,6":                      return "iPad 6"
            case "iPad2,5", "iPad2,6", "iPad2,7":           return "iPad Mini"
            case "iPad4,4", "iPad4,5", "iPad4,6":           return "iPad Mini 2"
            case "iPad4,7", "iPad4,8", "iPad4,9":           return "iPad Mini 3"
            case "iPad5,1", "iPad5,2":                      return "iPad Mini 4"
            case "iPad6,3", "iPad6,4":                      return "iPad Pro (9.7-inch)"
            case "iPad6,7", "iPad6,8":                      return "iPad Pro (12.9-inch)"
            case "iPad7,1", "iPad7,2":                      return "iPad Pro (12.9-inch) (2nd generation)"
            case "iPad7,3", "iPad7,4":                      return "iPad Pro (10.5-inch)"
            case "iPad8,1", "iPad8,2", "iPad8,3", "iPad8,4":return "iPad Pro (11-inch)"
            case "iPad8,5", "iPad8,6", "iPad8,7", "iPad8,8":return "iPad Pro (12.9-inch) (3rd generation)"
            case "AppleTV5,3":                              return "Apple TV"
            case "AppleTV6,2":                              return "Apple TV 4K"
            case "AudioAccessory1,1":                       return "HomePod"
            case "i386", "x86_64":                          return "Simulator \(mapToDevice(identifier: ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] ?? "iOS"))"
            default:                                        return identifier
            }
            #elseif os(tvOS)
            switch identifier {
            case "AppleTV5,3": return "Apple TV 4"
            case "AppleTV6,2": return "Apple TV 4K"
            case "i386", "x86_64": return "Simulator \(mapToDevice(identifier: ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] ?? "tvOS"))"
            default: return identifier
            }
            #endif
        }
        
        return mapToDevice(identifier: identifier)
    }()
    var hasNotch: Bool {
          let bottom = UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0
          return bottom > 0
      }
}

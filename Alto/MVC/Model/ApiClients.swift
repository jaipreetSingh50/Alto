//
//  ApiClients.swift
//  PinBy
//
//  Created by Jaypreet on 30/12/19.
//  Copyright © 2019 Jaipreet. All rights reserved.
//

import Foundation
import UIKit
import NetworkExtension
import Alamofire


class APIClients : NSObject {


    func getIPAddress() -> String {
        
    
        
        var address: String = ""
//        var ifaddr: UnsafeMutablePointer<ifaddrs>? = nil
//        if getifaddrs(&ifaddr) == 0 {
//            var ptr = ifaddr
//            while ptr != nil {
//                defer { ptr = ptr?.pointee.ifa_next }
//                
//                let interface = ptr?.pointee
//                let addrFamily = interface?.ifa_addr.pointee.sa_family
//                if  addrFamily == UInt8(AF_INET6) {
//                    
//                      if let name: String = String(cString: (interface?.ifa_name)!), name == "en0" {
//                        var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
//                        getnameinfo(interface?.ifa_addr, socklen_t((interface?.ifa_addr.pointee.sa_len)!), &hostname, socklen_t(hostname.count), nil, socklen_t(0), NI_NUMERICHOST)
//                        address = String(cString: hostname)
//                        print(address)
//                     }
//                }
//            }
//            freeifaddrs(ifaddr)
//        }
         return address
    }
    func getHeader() -> HTTPHeaders {

        let headers: HTTPHeaders = ["Accept": "application/json",
                      "Authorization" : "Bearer " + DataManager.Auth_Token!,
                      "user_type" : DataManager.CurrentUserRole!,
                      "language" : DataManager.CurrentAppLanguage!,
        ]
        print(headers)
        return headers
    }
    
    //MARK:  loginWithEmail
    static func RegisterAndUpdateProfile(
            parems: [String : Any],
            storyBoard : UIStoryboard,
            navigation : UIViewController,
            successResponse: @escaping (Result<M_CurrentUserData>)->Void,
            failure: @escaping (Result<String>) -> Void
            ) {
           
            DataModelCode().GetApi(Url: Constants.API.POST_register ,  method: .post , params : parems , headers: APIClients().getHeader() , storyBoard: storyBoard, navigation: navigation, Completion: successResponse, failure: failure)
          
        }
    static func Social_Login(
            parems: [String : Any],
            storyBoard : UIStoryboard,
            navigation : UIViewController,
            successResponse: @escaping (Result<M_CurrentUserData>)->Void,
            failure: @escaping (Result<String>) -> Void
            ) {
           
            DataModelCode().GetApi(Url: Constants.API.POST_social_login ,  method: .post , params : parems , headers: APIClients().getHeader() , storyBoard: storyBoard, navigation: navigation, Completion: successResponse, failure: failure)
          
        }
    //MARK:  loginWithEmail
    static func POST_login(
            parems: [String : Any],
            storyBoard : UIStoryboard,
            navigation : UIViewController,
            successResponse: @escaping (Result<M_CurrentUserData>)->Void,
            failure: @escaping (Result<String>) -> Void
            ) {
           
            DataModelCode().GetApi(Url: Constants.API.POST_login ,  method: .post , params : parems , headers: APIClients().getHeader() , storyBoard: storyBoard, navigation: navigation, Completion: successResponse, failure: failure)
          
        }
    static func POST_user_updateSeniorAddress(
            parems: [String : Any],
            storyBoard : UIStoryboard,
            navigation : UIViewController,
            successResponse: @escaping (Result<M_CurrentUserData>)->Void,
            failure: @escaping (Result<String>) -> Void
            ) {
           
            DataModelCode().GetApi(Url: Constants.API.POST_user_updateSeniorAddress ,  method: .post , params : parems , headers: APIClients().getHeader() , storyBoard: storyBoard, navigation: navigation, Completion: successResponse, failure: failure)
          
        }
    static func POST_country_list(
            parems: [String : Any],
            storyBoard : UIStoryboard,
            navigation : UIViewController,
            successResponse: @escaping (Result<M_Country>)->Void,
            failure: @escaping (Result<String>) -> Void
            ) {
           
            DataModelCode().GetApi(Url: Constants.API.POST_country_list ,  method: .get , params : parems , headers: APIClients().getHeader() , storyBoard: storyBoard, navigation: navigation, Completion: successResponse, failure: failure)
          
        }
    static func POST_state_list(
            parems: [String : Any],
            storyBoard : UIStoryboard,
            navigation : UIViewController,
            successResponse: @escaping (Result<M_Sate>)->Void,
            failure: @escaping (Result<String>) -> Void
            ) {
           
            DataModelCode().GetApi(Url: Constants.API.POST_state_list ,  method: .post , params : parems , headers: APIClients().getHeader() , storyBoard: storyBoard, navigation: navigation, Completion: successResponse, failure: failure)
          
        }
    static func POST_city_list(
            parems: [String : Any],
            storyBoard : UIStoryboard,
            navigation : UIViewController,
            successResponse: @escaping (Result<M_City>)->Void,
            failure: @escaping (Result<String>) -> Void
            ) {
           
            DataModelCode().GetApi(Url: Constants.API.POST_city_list ,  method: .post , params : parems , headers: APIClients().getHeader() , storyBoard: storyBoard, navigation: navigation, Completion: successResponse, failure: failure)
          
        }
    static func POST_categories(
            parems: [String : Any],
            storyBoard : UIStoryboard,
            navigation : UIViewController,
            successResponse: @escaping (Result<M_Categories>)->Void,
            failure: @escaping (Result<String>) -> Void
            ) {
           
            DataModelCode().GetApi(Url: Constants.API.POST_categories ,  method: .post , params : parems , headers: APIClients().getHeader() , storyBoard: storyBoard, navigation: navigation, Completion: successResponse, failure: failure)
          
        }
    static func POST_user_updateCompanion(
            parems: [String : Any],
            storyBoard : UIStoryboard,
            navigation : UIViewController,
            successResponse: @escaping (Result<M_CurrentUserData>)->Void,
            failure: @escaping (Result<String>) -> Void
            ) {
           
            DataModelCode().GetApi(Url: Constants.API.POST_user_updateCompanion ,  method: .post , params : parems , headers: APIClients().getHeader() , storyBoard: storyBoard, navigation: navigation, Completion: successResponse, failure: failure)
          
        }
    static func POST_user_addCard(
            parems: [String : Any],
            storyBoard : UIStoryboard,
            navigation : UIViewController,
            successResponse: @escaping (Result<M_CurrentUserData>)->Void,
            failure: @escaping (Result<String>) -> Void
            ) {
           
            DataModelCode().GetApi(Url: Constants.API.POST_user_addCard ,  method: .post , params : parems , headers: APIClients().getHeader() , storyBoard: storyBoard, navigation: navigation, Completion: successResponse, failure: failure)
          
        }
    static func POST_user_nearbyCompanion(
            parems: [String : Any],
            storyBoard : UIStoryboard,
            navigation : UIViewController,
            successResponse: @escaping (Result<M_drivers>)->Void,
            failure: @escaping (Result<String>) -> Void
            ) {
           
            DataModelCode().GetApi(Url: Constants.API.POST_user_nearbyCompanion ,  method: .post , params : parems , headers: APIClients().getHeader() , storyBoard: storyBoard, navigation: navigation, Completion: successResponse, failure: failure)
          
        }
    static func POST_user_nearbySenior(
            parems: [String : Any],
            storyBoard : UIStoryboard,
            navigation : UIViewController,
            successResponse: @escaping (Result<M_drivers>)->Void,
            failure: @escaping (Result<String>) -> Void
            ) {
           
            DataModelCode().GetApi(Url: Constants.API.POST_user_nearbySenior ,  method: .post , params : parems , headers: APIClients().getHeader() , storyBoard: storyBoard, navigation: navigation, Completion: successResponse, failure: failure)
          
        }

    static func POST_user_createRequest(
            parems: [String : Any],
            storyBoard : UIStoryboard,
            navigation : UIViewController,
            successResponse: @escaping (Result<M_Request>)->Void,
            failure: @escaping (Result<String>) -> Void
            ) {
           
            DataModelCode().GetApi(Url: Constants.API.POST_user_createRequest ,  method: .post , params : parems , headers: APIClients().getHeader() , storyBoard: storyBoard, navigation: navigation, Completion: successResponse, failure: failure)
          
        }
    static func POST_user_meetingDetail(
            parems: [String : Any],
            storyBoard : UIStoryboard,
            navigation : UIViewController,
            successResponse: @escaping (Result<M_Request>)->Void,
            failure: @escaping (Result<String>) -> Void
            ) {
           
            DataModelCode().GetApi(Url: Constants.API.POST_user_meetingDetail ,  method: .post , params : parems , headers: APIClients().getHeader() , storyBoard: storyBoard, navigation: navigation, Completion: successResponse, failure: failure)
          
        }

    static func POST_user_companion_detail(
            parems: [String : Any],
        loader : Bool = true,
        alert : Bool = true,

            storyBoard : UIStoryboard,
            navigation : UIViewController,
            successResponse: @escaping (Result<M_Other_User>)->Void,
            failure: @escaping (Result<String>) -> Void
            ) {
           
        DataModelCode().GetApi(Url: Constants.API.POST_user_companion_detail ,  method: .post , params : parems , headers: APIClients().getHeader(), loader : loader, alert: alert , storyBoard: storyBoard, navigation: navigation, Completion: successResponse, failure: failure)
          
        }
    
    static func POST_user_opentok_notification(
            parems: [String : Any],
            storyBoard : UIStoryboard,
            navigation : UIViewController,
            successResponse: @escaping (Result<M_Message>)->Void,
            failure: @escaping (Result<String>) -> Void
            ) {
           
            DataModelCode().GetApi(Url: Constants.API.POST_user_opentok_notification ,  method: .post , params : parems , headers: APIClients().getHeader() , storyBoard: storyBoard, navigation: navigation, Completion: successResponse, failure: failure)
          
        }
    
    static func POST_user_meetingPaid(
            parems: [String : Any],
        loader : Bool = true,
        alert : Bool = true,
            storyBoard : UIStoryboard,
            navigation : UIViewController,

            successResponse: @escaping (Result<M_Message>)->Void,
            failure: @escaping (Result<String>) -> Void
            ) {
           
        DataModelCode().GetApi(Url: Constants.API.POST_user_meetingPaid ,  method: .post , params : parems , headers: APIClients().getHeader() ,loader : loader, alert : alert, storyBoard: storyBoard, navigation: navigation, Completion: successResponse, failure: failure)
          
        }
    static func POST_user_meetingStatusChange(
            parems: [String : Any],
        loader : Bool = true,
        alert : Bool = true,
            storyBoard : UIStoryboard,
            navigation : UIViewController,

            successResponse: @escaping (Result<M_Message>)->Void,
            failure: @escaping (Result<String>) -> Void
            ) {
           
        DataModelCode().GetApi(Url: Constants.API.POST_user_meetingStatusChange ,  method: .post , params : parems , headers: APIClients().getHeader() ,loader : loader, alert : alert, storyBoard: storyBoard, navigation: navigation, Completion: successResponse, failure: failure)
          
        }

    static func POST_user_userdeleteAddress(
            parems: [String : Any],
            storyBoard : UIStoryboard,
            navigation : UIViewController,
            successResponse: @escaping (Result<M_Message>)->Void,
            failure: @escaping (Result<String>) -> Void
            ) {
           
            DataModelCode().GetApi(Url: Constants.API.POST_user_userdeleteAddress ,  method: .post , params : parems , headers: APIClients().getHeader() , storyBoard: storyBoard, navigation: navigation, Completion: successResponse, failure: failure)
          
        }
    static func POST_user_addReview(
            parems: [String : Any],
            storyBoard : UIStoryboard,
            navigation : UIViewController,
            successResponse: @escaping (Result<M_Message>)->Void,
            failure: @escaping (Result<String>) -> Void
            ) {
           
            DataModelCode().GetApi(Url: Constants.API.POST_user_addReview ,  method: .post , params : parems , headers: APIClients().getHeader() , storyBoard: storyBoard, navigation: navigation, Completion: successResponse, failure: failure)
          
        }
    static func POST_forgot_password(
            parems: [String : Any],
            storyBoard : UIStoryboard,
            navigation : UIViewController,
            successResponse: @escaping (Result<M_Message>)->Void,
            failure: @escaping (Result<String>) -> Void
            ) {
           
            DataModelCode().GetApi(Url: Constants.API.POST_forgot_password ,  method: .post , params : parems , headers: APIClients().getHeader() , storyBoard: storyBoard, navigation: navigation, Completion: successResponse, failure: failure)
          
        }
    static func POST_Change_password(
            parems: [String : Any],
            storyBoard : UIStoryboard,
            navigation : UIViewController,
            successResponse: @escaping (Result<M_Message>)->Void,
            failure: @escaping (Result<String>) -> Void
            ) {
           
            DataModelCode().GetApi(Url: Constants.API.POST_Change_password ,  method: .post , params : parems , headers: APIClients().getHeader() , storyBoard: storyBoard, navigation: navigation, Completion: successResponse, failure: failure)
          
        }

    //MARK:  loginWithEmail
    static func POST_user_updateCompanion2(
            parems:  [String : Any] = ["":""],
            imageKey : [String] = [],
            image : [UIImage] = [],
            OtherData : [Data] = [],
            OtherDataKey : [String] = [] ,

            storyBoard : UIStoryboard,
            navigation : UIViewController,
            successResponse: @escaping (Result<M_CurrentUserData>)->Void,
            failure: @escaping (Result<String>) -> Void,
        progressUpload: @escaping (_ result:(Int) ) -> Void

            ) {
            DataModelCode().UploadDataWithTokenMultipleImageData(Url: Constants.API.POST_user_updateCompanion2, method: .post, params: parems, headers: APIClients().getHeader(),  image: image, imageKey: imageKey,  storyBoard: storyBoard, navigation: navigation, Completion: successResponse, failure: failure, progressUpload: progressUpload)
       
          
        }
    
    
    static func POST_user_getReview(
            parems: [String : Any],
            storyBoard : UIStoryboard,
            navigation : UIViewController,
            successResponse: @escaping (Result<M_Review>)->Void,
            failure: @escaping (Result<String>) -> Void
            ) {
           
            DataModelCode().GetApi(Url: Constants.API.POST_user_getReview ,  method: .post , params : parems , headers: APIClients().getHeader() , storyBoard: storyBoard, navigation: navigation, Completion: successResponse, failure: failure)
          
        }
    static func POST_updateConnect(
            parems: [String : Any],
            storyBoard : UIStoryboard,
            navigation : UIViewController,
            successResponse: @escaping (Result<M_Message>)->Void,
            failure: @escaping (Result<String>) -> Void
            ) {
           
            DataModelCode().GetApi(Url: Constants.API.POST_updateConnect ,  method: .get , params : parems , headers: APIClients().getHeader() , storyBoard: storyBoard, navigation: navigation, Completion: successResponse, failure: failure)
          
        }
    static func POST_stripeKeyInfo(
            parems: [String : Any],
            storyBoard : UIStoryboard,
            navigation : UIViewController,
            successResponse: @escaping (Result<M_Stripe>)->Void,
            failure: @escaping (Result<String>) -> Void
            ) {
           
            DataModelCode().GetApi(Url: Constants.API.POST_stripeKeyInfo ,  method: .post , params : parems , headers: APIClients().getHeader() , storyBoard: storyBoard, navigation: navigation, Completion: successResponse, failure: failure)
          
        }
    
    static func POST_user_updateCompanion3(
            parems:  [String : Any] = ["":""],
            imageKey : [String] = [],
            image : [UIImage] = [],
            OtherData : [Data] = [],
            OtherDataKey : [String] = [] ,

            storyBoard : UIStoryboard,
            navigation : UIViewController,
            successResponse: @escaping (Result<M_CurrentUserData>)->Void,
            failure: @escaping (Result<String>) -> Void,
        progressUpload: @escaping (_ result:(Int) ) -> Void

            ) {
        DataModelCode().UploadDataWithTokenMultipleImageData(Url: Constants.API.POST_user_updateCompanion3, method: .post, params: parems, headers: APIClients().getHeader(),  OtherData : OtherData, OtherDataKey : OtherDataKey, image: image, imageKey: imageKey,  storyBoard: storyBoard, navigation: navigation, Completion: successResponse, failure: failure, progressUpload: progressUpload)
       
          
        }
    static func POST_user_ProfileCompanion3(
            parems:  [String : Any] = ["":""],
            imageKey : [String] = [],
            image : [UIImage] = [],
            OtherData : [Data] = [],
            OtherDataKey : [String] = [] ,

            storyBoard : UIStoryboard,
            navigation : UIViewController,
            successResponse: @escaping (Result<M_CurrentUserData>)->Void,
            failure: @escaping (Result<String>) -> Void,
        progressUpload: @escaping (_ result:(Int) ) -> Void

            ) {
        DataModelCode().UploadDataWithTokenMultipleImageData(Url: Constants.API.POST_user_update_profile, method: .post, params: parems, headers: APIClients().getHeader(),  OtherData : OtherData, OtherDataKey : OtherDataKey, image: image, imageKey: imageKey,  storyBoard: storyBoard, navigation: navigation, Completion: successResponse, failure: failure, progressUpload: progressUpload)
       
          
        }
    
    //MARK:  loginWithEmail
    static func POST_user_update_profile(
            parems:  [String : Any] = ["":""],
            imageKey : [String] = [],
            image : [UIImage] = [],

            storyBoard : UIStoryboard,
            navigation : UIViewController,
            successResponse: @escaping (Result<M_CurrentUserData>)->Void,
            failure: @escaping (Result<String>) -> Void,
        progressUpload: @escaping (_ result:(Int) ) -> Void

            ) {
        DataModelCode().UploadDataWithTokenMultipleImageData(Url: Constants.API.POST_user_update_profile, method: .post, params: parems, headers: APIClients().getHeader(),  image: image, imageKey: imageKey,  storyBoard: storyBoard, navigation: navigation, Completion: successResponse, failure: failure, progressUpload: progressUpload)
       
          
        }
    static func uploadLocation(
            parems:  [String : Any] = ["":""],
            loader : Bool = true,
            alert : Bool = true,
            storyBoard : UIStoryboard,
            navigation : UIViewController,
            successResponse: @escaping (Result<M_CurrentUserData>)->Void,
            failure: @escaping (Result<String>) -> Void,
            progressUpload: @escaping (_ result:(Int) ) -> Void

            ) {
            
            DataModelCode().GetApi(Url: Constants.API.POST_user_update_profile ,  method: .post , params : parems , headers: APIClients().getHeader() , storyBoard: storyBoard, navigation: navigation, Completion: successResponse, failure: failure)
          
        }
    static func POST_user_opentok_session(
            parems:  [String : Any] = ["":""],
            loader : Bool = true,
            alert : Bool = true,
            storyBoard : UIStoryboard,
            navigation : UIViewController,
            successResponse: @escaping (Result<M_OpenTox>)->Void,
            failure: @escaping (Result<String>) -> Void,
            progressUpload: @escaping (_ result:(Int) ) -> Void

            ) {
            
            DataModelCode().GetApi(Url: Constants.API.POST_user_opentok_session ,  method: .post , params : parems , headers: APIClients().getHeader() , storyBoard: storyBoard, navigation: navigation, Completion: successResponse, failure: failure)
          
        }
    static func UpdateProfile(
            parems:  [String : Any] = ["":""],
            imageKey : [String] = [],
            image : [UIImage] = [],
        loader : Bool = true,
        alert : Bool = true,
            storyBoard : UIStoryboard,
            navigation : UIViewController,
            successResponse: @escaping (Result<M_CurrentUserData>)->Void,
            failure: @escaping (Result<String>) -> Void,
        progressUpload: @escaping (_ result:(Int) ) -> Void

            ) {
        DataModelCode().UploadDataWithTokenMultipleImageData(Url: Constants.API.POST_user_update_profile, method: .post, params: parems, headers: APIClients().getHeader(),  image: image, imageKey: imageKey, loader : loader,alert : alert,  storyBoard: storyBoard, navigation: navigation, Completion: successResponse, failure: failure, progressUpload: progressUpload)
       
          
        }
    static func POST_user_meetingSeniorList(
            parems: [String : Any],
            storyBoard : UIStoryboard,
            navigation : UIViewController,
            successResponse: @escaping (Result<M_Meeting>)->Void,
            failure: @escaping (Result<String>) -> Void
            ) {
           
            DataModelCode().GetApi(Url: Constants.API.POST_user_meetingSeniorList ,  method: .post , params : parems , headers: APIClients().getHeader() , storyBoard: storyBoard, navigation: navigation, Completion: successResponse, failure: failure)
          
        }
    
    static func POST_user_meetingSeniorListCal(
            parems: [String : Any],

            successResponse: @escaping (Result<M_Meeting>)->Void,
            failure: @escaping (Result<String>) -> Void
            ) {
           
            DataModelCode().GetWithoutStoryboard(Url: Constants.API.POST_user_meetingSeniorList ,  method: .post , params : parems , headers: APIClients().getHeader(), Completion: successResponse, failure: failure)
          
        }
    static func POST_user_meetingCompanionListCal(
            parems: [String : Any],
            successResponse: @escaping (Result<M_Meeting>)->Void,
            failure: @escaping (Result<String>) -> Void
            ) {
           
            DataModelCode().GetWithoutStoryboard(Url: Constants.API.POST_user_meetingCompanionList ,  method: .post , params : parems , headers: APIClients().getHeader(), Completion: successResponse, failure: failure)
          
        }
    static func POST_user_meetingCompanionList(
            parems: [String : Any],
            storyBoard : UIStoryboard,
            navigation : UIViewController,
            successResponse: @escaping (Result<M_Meeting>)->Void,
            failure: @escaping (Result<String>) -> Void
            ) {
           
            DataModelCode().GetApi(Url: Constants.API.POST_user_meetingCompanionList ,  method: .post , params : parems , headers: APIClients().getHeader() , storyBoard: storyBoard, navigation: navigation, Completion: successResponse, failure: failure)
          
        }
    static func POST_user_notification_list(
            parems: [String : Any],
            storyBoard : UIStoryboard,
            navigation : UIViewController,
            successResponse: @escaping (Result<M_Notification>)->Void,
            failure: @escaping (Result<String>) -> Void
            ) {
           
            DataModelCode().GetApi(Url: Constants.API.POST_user_notification_list ,  method: .get , params : parems , headers: APIClients().getHeader() , storyBoard: storyBoard, navigation: navigation, Completion: successResponse, failure: failure)
          
        }
    static func POST_user_adminDetails(
            parems: [String : Any],
            storyBoard : UIStoryboard,
            navigation : UIViewController,
            successResponse: @escaping (Result<M_Admin>)->Void,
            failure: @escaping (Result<String>) -> Void
            ) {
           
            DataModelCode().GetApi(Url: Constants.API.POST_user_adminDetails ,  method: .get , params : parems , headers: APIClients().getHeader() , storyBoard: storyBoard, navigation: navigation, Completion: successResponse, failure: failure)
          
        }
    
}

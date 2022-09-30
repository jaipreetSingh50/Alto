//
//  Models.swift
//  GoRINSE
//
//  Created by Jaypreet on 24/08/18.
//  Copyright © 2018 Jaypreet. All rights reserved.
//

import Foundation
import UIKit



// MARK: - Success Message
struct M_Message: Codable {
    let message: String
}

struct M_Country: Codable {
    let data: [M_Country_data]
}

struct M_Country_data: Codable {
    let sortname: String
    let phonecode: Int
    let name: String
    let id: Int

}

struct M_Sate: Codable {
    let data: [M_State_data]
}

struct M_State_data: Codable {
    let country_id: Int
    let name: String
    let id: Int
}
struct M_City: Codable {
    let data: [M_City_data]
}

struct M_City_data: Codable {
    let state_id: Int
    let name: String
    let id: Int
}


struct M_Categories: Codable {
    let categories: M_CategoriesL
}
struct M_CategoriesL: Codable {
    let offline: M_CategoriesList
    let online: M_CategoriesList

    
    
}

struct M_CategoriesList: Codable {
    let data: [M_Categories_data]
}
struct M_Categories_data: Codable {
   
    let name: String
    let id: Int

}


struct M_drivers: Codable {
    let drivers: [M_drivers_data]
}
struct M_drivers_data: Codable {
   
    let phone: String
    let availability: Int
    let current_lat: String
    let current_lng: String
    let distance: Double
    let email: String
    let full_name: String
    let user_name: String
    let address : [M_Address]
    let id: Int

}


// MARK: - CurrentUserData
struct M_Other_User: Codable {
    let message: String
    let data: M_User
}

// MARK: - User
struct M_User: Codable {

    let availability : Int
    let exp : String?
    let rating : String?
    let tasks : String?

    let country_code  : Int
    let country_code_text : String?
    let current_lat : String?
    let current_lng : String?
    let dob : String?
    let email : String?
    let first_name : String?
    let full_name : String?
    let last_name : String?
    let user_name : String?

    let id  : Int
    let image : String?
    let notification  : Int
    let notification_count  : Int?
    let phone : String?
    let status  : Int
    let verify  : Int
    let other_data  : M_other_data?
}

struct M_Request: Codable {
    let message: String
    let data : M_Request_Data
}
struct M_Request_Data: Codable {
    let address_id: Int
    let companion_id: Int
    let end_time: String
    let id: Int
    var status: Int
    var paid: Int?

    let request_date: String
    let schedule: Int
    let start_time: String
    let task: String
    let cost : String
    let meeting_type: Int?
    let meeting_lang : String?
    let user_id: Int
    let senior_data : M_User?
    let companion_data: M_User?
    let address_data : M_Address?
//    let new: Int
    let created_at : String

}
struct M_Meeting: Codable {
    let message: String
    let data : [M_Request_Data]
}



struct M_Admin: Codable {
    let message: String
    let data : M_Admin_Data
}
struct M_Admin_Data: Codable {
    let companion_cancel_policy: String
    let phone_number: String
    let senior_cancel_policy: String
    let hourly_rate : String
   

    let cancel_reasons : [M_cancel_reasons]
}
struct M_cancel_reasons: Codable {
    let reason: String
}
struct M_Review: Codable {
    let message: String
    let data : [M_Review_Data]
}
struct M_Review_Data: Codable {
    let detail: String
    let created_at: String
    let enjoy: String
    let rate : String
    let reschedule : Int

    let user_data : M_User
}
struct M_Notification: Codable {
    let message: String
    let data : [M_Notification_Data]
}
struct M_Notification_Data: Codable {
    let description: String
    let created_at: String
    let title: String
    let user_name : String
    let user_image : String

    let id : Int

}
struct M_OpenTox: Codable {
    let opentok_token: String
    let sessiontoken: String
   


}
struct M_Stripe: Codable {
    let message: String
    let data : M_Stripe_Data
}
struct M_Stripe_Data: Codable {
    let customer: String
    let ephemeralKey: String
    let paymentIntent: String
    let publishableKey : String
   

}

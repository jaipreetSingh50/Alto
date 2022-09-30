//
//  CurrentUser.swift
//  Snatchem
//
//  Created by Apple on 07/03/18.
//  Copyright © 2018 OREM TECH. All rights reserved.
//

import Foundation





// MARK: - CurrentUserData
struct M_CurrentUserData: Codable {
    let message: String?
    let user: User
    let token: String?
}

// MARK: - User
struct User: Codable {
//    let new : Int

    let availability : Int
    let card_data : [M_card_data]?
    var address : [M_Address]?

    let country_code  : Int
    let country_code_text : String?
    let current_lat : String?
    let current_lng : String?
    let dob : String?
    let email : String?
    let first_name : String?
    let full_name : String?
    let user_name : String?
    let gender : Int?

    let last_name : String?
    let id  : Int
    let image : String?
    let notification  : Int
    let notification_count  : Int
    let phone : String?
    let status  : Int
    let verify  : Int
    let other_data  : M_other_data?

    let connect_id : String


    





    

}


struct M_card_data: Codable {
    let brand_name : String
    let card_number : String
    let expiry : String
    let is_billing_address : Int
    let id : Int

    let name : String

}
struct M_Address: Codable {
    let address : String
    let city : String
    let country : String
    let user_id : Int
    let id : Int
    let zip_code : String
    let lat : String
    let lng : String
    let complete_address : String

    let state : String

}
struct M_other_data: Codable {
    let IBAN : String
    let address : String
    let area : String
    let bio : String
    let city : String
    let country : String
    let criminal_record : String
    let dob : String
    let gender : String
    let hourly_rate : String
    let id_proof : String
    let language_speak : String
    let license : String
    let preferred_city : String
    let profile_image : String
    let refer_name : String
    let skills : String
    let state : String
    let work_days : String
    let zip_code : String
    let preferred_meeting : Int?

    let have_car : Int
    let id : Int


}

//
//  SeniorSettingViewController.swift
//  Alto
//
//  Created by Jaypreet on 26/10/21.
//

import UIKit
import FlagPhoneNumber

class SeniorSettingViewController: UIViewController {

    @IBOutlet weak var lblLastName: UITextField!
    @IBOutlet weak var DOB: UIDatePicker!
    @IBOutlet weak var txtPhoneNumber: FPNTextField!
    @IBOutlet weak var txtUserName: UITextField!
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var imgUser: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        txtName.text = Constants.CurrentUserData.first_name
        txtUserName.text = Constants.CurrentUserData.user_name
        imgUser.getImage(url: Constants.CurrentUserData.image ?? "")

        lblLastName.text = Constants.CurrentUserData.last_name
        txtPhoneNumber.text = Constants.CurrentUserData.phone
        let repository: FPNCountryRepository = txtPhoneNumber.countryRepository
        if repository.countries.filter({ ($0.phoneCode == Constants.CurrentUserData.country_code_text)}).count != 0{
            let i = repository.countries.filter({ ($0.phoneCode == Constants.CurrentUserData.country_code_text)})[0].code
            txtPhoneNumber.setFlag(countryCode: FPNCountryCode(rawValue: i.rawValue)!)
        }
        DOB.date = Constants.CurrentUserData.dob?.GetDateFromString(format: DateFormat.dd_MM_yyyy.get()) ?? Date()
        let calendar = Calendar(identifier: .gregorian)

         let currentDate = Date()
         var components = DateComponents()
         components.calendar = calendar

         components.year = -18
         components.month = 12
         let maxDate = calendar.date(byAdding: components, to: currentDate)!

         components.year = -150
         let minDate = calendar.date(byAdding: components, to: currentDate)!
        DOB.minimumDate = minDate
        DOB.maximumDate = maxDate
        // Do any additional setup after loading the view.
    }
    
    @IBAction func Back(_ sender: Any) {
        dismiss()
    }
    @IBAction func Continue(_ sender: Any) {
        apiUpdateProfile()
    }
    func apiUpdateProfile() {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        let dateDOB = formatter.string(from: DOB.date)
        let dict = [
            "device_token" : DataManager.device_token!,
            "device_type" : "ios",
            "current_lng" : Current_lng,
            "current_lat" : Current_lat,
            "dob" : dateDOB,
            "user_name" : txtUserName.text!,

            "first_name" : txtName.text!,
            "last_name" : lblLastName.text!,
            "phone" : txtPhoneNumber.text!,
            "country_code" : txtPhoneNumber.selectedCountry?.phoneCode as Any ,
            "country_code_text" : txtPhoneNumber.selectedCountry?.code.rawValue as Any
            
            
        ] as! [String : String]
        
        APIClients.uploadLocation(parems: dict   , loader : false  , alert : false ,storyBoard: storyboard!, navigation: self) { (result) in
            switch result {
            case .success(let response):
                print(response)
                DataManager.CurrentUserData = response.user
                Constants.CurrentUserData = response.user
                NotificationCenter.default.post(name: Notification.Name.NotificationUpdateProfile, object: [:])
                let when = DispatchTime.now() + 0
                DispatchQueue.main.asyncAfter(deadline: when)
                {
                    self.dismiss()
                   
                }
            case .failure(let error):
                print(error)
            }
            
        } failure: { (error) in
            
        } progressUpload: { (per) in
            print(per)
        }

    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

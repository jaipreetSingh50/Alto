//
//  SeniorSignup1ViewController.swift
//  Alto
//
//  Created by Jaypreet on 22/10/21.
//

import UIKit
import FlagPhoneNumber


class SeniorSignup1ViewController: UIViewController {
    @IBOutlet weak var txtFirstName: UITextField!
    
    @IBOutlet weak var DOB: UIDatePicker!
    @IBOutlet weak var txtPhone: FPNTextField!
    @IBOutlet weak var txtLastName: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
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
        Dismiss()
    }
    
    @IBAction func Continue(_ sender: Any) {
       

        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        let dateDOB = formatter.string(from: DOB.date)
            
        let dict = ["first_name" : txtFirstName.text!,
                    "last_name" : txtLastName.text!,
                    "dob" : dateDOB,
                    "user_type" :  DataManager.CurrentUserRole as Any ,
                    "phone" : txtPhone.text!,
                    "country_code" : txtPhone.selectedCountry?.phoneCode as Any ,
                    "country_code_text" : txtPhone.selectedCountry?.code.rawValue as Any] as [String : Any]
        print(dict)
        
        if txtFirstName.CheckText() && txtLastName.CheckText() && txtPhone.CheckText() {
            let vc = storyboard?.instantiateViewController(identifier: "SeniorSignup2ViewController") as! SeniorSignup2ViewController
            vc.modalPresentationStyle = .fullScreen
            vc.Dict = NSMutableDictionary.init(dictionary: dict)
            present(vc, animated: true, completion: nil)
        }
    }
    
    
    func ApiRegister()  {

        
        
        
        
        
        
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

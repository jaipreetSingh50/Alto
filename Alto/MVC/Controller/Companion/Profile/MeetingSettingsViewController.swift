//
//  MeetingSettingsViewController.swift
//  Alto
//
//  Created by Jaypreet on 19/01/22.
//

import UIKit

class MeetingSettingsViewController: UIViewController {
    @IBOutlet weak var lblIdontHave: UILabel!
    @IBOutlet weak var lblIHave: UILabel!
    @IBOutlet weak var btnHaveCar: UIButton!
    
    @IBOutlet weak var sgtMeeting: UISegmentedControl!
    @IBOutlet weak var txtLanguage: UITextField!
    @IBOutlet weak var txtAvailabity: UITextField!
    @IBOutlet weak var btnDontHaveCar: UIButton!
    @IBOutlet weak var lblCity: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        sgtMeeting.selectedSegmentIndex = (Constants.CurrentUserData.other_data?.preferred_meeting ?? 2) - 1
        lblCity.text = Constants.CurrentUserData.other_data?.preferred_city
        txtLanguage.text = Constants.CurrentUserData.other_data?.language_speak
        txtAvailabity.text = Constants.CurrentUserData.other_data?.work_days
        Setcar(car: Constants.CurrentUserData.other_data?.have_car ?? 0)

        // Do any additional setup after loading the view.
    }
    @IBAction func Back(_ sender: Any) {
        dismiss()
    }
    @IBAction func Availablity(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "PopUpSelectionViewController") as! PopUpSelectionViewController
        vc.modalPresentationStyle = .overFullScreen
        vc.ArrayValues = ["Monday", "Tuesday" , "Wednesday" , "Thursday" , "Friday" , "Saturday" , "Sunday"]
        vc.ViewType = 2
        vc.ViewTitle = "Select Availablity"
        vc.delegate = self
        present(vc, animated: false)
    }
    
    @IBAction func Language(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "PopUpSelectionViewController") as! PopUpSelectionViewController
        vc.modalPresentationStyle = .overFullScreen
        vc.ArrayValues = ["English", "French"  , "Italian" , "German" ]
        vc.ViewTitle = "Select Languages"
        vc.delegate = self
        vc.ViewType = 1
        present(vc, animated: false)
    }
    
    @IBAction func Car(_ sender: UIButton) {
        Setcar(car: sender.tag)
    }
    func Setcar(car : Int) {
        switch car {
        case 1:
            btnHaveCar.isSelected = true
                btnDontHaveCar.isSelected = false
            lblIHave.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            lblIdontHave.textColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        default:
            btnHaveCar.isSelected = false
            btnDontHaveCar.isSelected = true
            lblIHave.textColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
            lblIdontHave.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        }
    }
    @IBAction func Save(_ sender: Any) {
        
        let hours : [[String : Any]] = [["hrs" : 10, "rate" : "10"],["hrs" : 15, "rate" : "10"],["hrs" : 20, "rate" : "10"]]
        let dict = [
            "hourly_rate" : CommonFunctions().convertIntoJSONString(arrayObject: hours)!,
            "preferred_city" : lblCity.text!,
            "work_days" : txtAvailabity.text!,
            "have_car" : btnHaveCar.isSelected ? 1 :0,
            "language_speak" : txtLanguage.text!,
            "preferred_meeting" : sgtMeeting.selectedSegmentIndex + 1
        ] as [String : Any]
        APIClients.POST_user_update_profile(parems: dict , storyBoard: storyboard!, navigation: self) { (result) in
            switch result {
            case .success(let response):
                print(response)
                Constants.CurrentUserData = response.user
                DataManager.CurrentUserData = response.user
                NotificationCenter.default.post(name: Notification.Name.NotificationUpdateProfile, object: [:])

                Constants.Toast.MyToast(message: response.message ?? ""   )
                let when = DispatchTime.now() + 1
                DispatchQueue.main.asyncAfter(deadline: when)
                {
                    self.dismiss()
                }
            case .failure(let error):
                print(error)
            }
        } failure: { (error) in
            print(error)
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
extension MeetingSettingsViewController : selectedItemsPopupDelegate{
    func SelectedPopUp(arr: [String], type: Int) {
        switch type {
        case 1:
            txtLanguage.text = arr.joined(separator: ",")
        case 2:
            txtAvailabity.text = arr.joined(separator: ",")
        default:
            break
        }
    }
}

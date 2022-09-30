//
//  CompanionSignup2ViewController.swift
//  Alto
//
//  Created by Jaypreet on 22/10/21.
//

import UIKit

class CompanionSignup2ViewController: UIViewController {

    @IBOutlet weak var txtCost20: UITextField!
    @IBOutlet weak var sgtMeetingType: UISegmentedControl!
    @IBOutlet weak var txtCost15: UITextField!
    @IBOutlet weak var lblReferred: UITextField!
    @IBOutlet weak var txtCost10: UITextField!
    @IBOutlet weak var lblLanguage: UITextField!
    @IBOutlet weak var txtAvailabity: UITextField!
    @IBOutlet weak var btnIdontHave: UIButton!
    @IBOutlet weak var btnIHave: UIButton!
    @IBOutlet weak var lblIdontHave: UILabel!
    @IBOutlet weak var lblIHave: UILabel!
    @IBOutlet weak var txtCity: UITextField!
    @IBOutlet weak var lblHrs1: UILabel!
    @IBOutlet weak var lblHrs2: UILabel!
    @IBOutlet weak var lblHrs3: UILabel!

    @IBOutlet weak var lblPayPrice1: UILabel!
    @IBOutlet weak var lblPayPrice2: UILabel!
    @IBOutlet weak var lblPayPrice3: UILabel!
    
    var PickerView : UIPickerView!

    var jTableView : ActionPickerController? {
        didSet{
            PickerView?.dataSource = jTableView
            PickerView?.delegate = jTableView
            PickerView?.reloadAllComponents()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        btnIHave.setImage(#imageLiteral(resourceName: "radio_button_on-1"), for: .selected)
        btnIHave.isSelected = true
        btnIdontHave.setImage(#imageLiteral(resourceName: "radio_button_on-1"), for: .selected)
        btnIHave.setImage(#imageLiteral(resourceName: "radio_button_off"), for: .normal)
        btnIdontHave.setImage(#imageLiteral(resourceName: "radio_button_off-1"), for: .normal)

        txtAvailabity.AddRightDropDownIcon(icon: #imageLiteral(resourceName: "ic_drop"))
        lblLanguage.AddRightDropDownIcon(icon: #imageLiteral(resourceName: "ic_drop"))

        // Do any additional setup after loading the view.
    }
    
    @IBAction func BAck(_ sender: Any) {
        Dismiss()
    }
    @IBAction func SetLanuage(_ sender: UIButton) {
  
        let vc = storyboard?.instantiateViewController(withIdentifier: "PopUpSelectionViewController") as! PopUpSelectionViewController
        vc.modalPresentationStyle = .overFullScreen
        vc.ArrayValues = ["English", "French"  , "Italian" , "German" ]
        vc.ViewTitle = "Select Languages"
        vc.delegate = self
        vc.ViewType = 1

        present(vc, animated: false)
    }
    @IBAction func SetAvailabity(_ sender: UIButton) {
      
        let vc = storyboard?.instantiateViewController(withIdentifier: "PopUpSelectionViewController") as! PopUpSelectionViewController
        vc.modalPresentationStyle = .overFullScreen
        vc.ArrayValues = ["Monday", "Tuesday" , "Wednesday" , "Thursday" , "Friday" , "Saturday" , "Sunday"]
        vc.ViewType = 2
        vc.ViewTitle = "Select Availablity"
        vc.delegate = self

        present(vc, animated: false)
    }
    @IBAction func Availablity(_ sender: UITextField) {
    }
    
    @IBAction func Car(_ sender: UIButton) {
        switch sender.tag {
        case 1:
            btnIHave.isSelected = true
            btnIdontHave.isSelected = false
            lblIHave.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            lblIdontHave.textColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)


        default:
            btnIHave.isSelected = false
            btnIdontHave.isSelected = true
            lblIHave.textColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
            lblIdontHave.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        }
    }
    @IBAction func Continue(_ sender: Any) {
        
        
        let hours : [[String : Any]] = [["hrs" : 10, "rate" : txtCost10.text!],["hrs" : 15, "rate" : txtCost15.text!],["hrs" : 20, "rate" : txtCost20.text!]]
        
        
        
        let dict = [
            "hourly_rate" : CommonFunctions().convertIntoJSONString(arrayObject: hours)!,
            "preferred_city" : txtCity.text!,
            "work_days" : txtAvailabity.text!,
            "have_car" : btnIHave.isSelected ? 1 :0,
            "refer_name" : lblReferred.text!,
            "language_speak" : lblLanguage.text!,
            "preferred_meeting" : sgtMeetingType.selectedSegmentIndex + 1
        ] as [String : Any]
        
        APIClients.POST_user_updateCompanion(parems: dict , storyBoard: storyboard!, navigation: self) { (result) in
            switch result {
            case .success(let response):
                print(response)
                Constants.Toast.MyToast(message: response.message ?? ""   )


                let when = DispatchTime.now() + 1
                DispatchQueue.main.asyncAfter(deadline: when)
                {
                    let vc = self.storyboard?.instantiateViewController(identifier: "CompanionSignup3ViewController") as! CompanionSignup3ViewController
                    vc.modalPresentationStyle = .fullScreen
                    self.present(vc, animated: true, completion: nil)
                }


            case .failure(let error):
                print(error)
            }
            
        } failure: { (error) in
            print(error)
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
extension CompanionSignup2ViewController : selectedItemsPopupDelegate{
    func SelectedPopUp(arr: [String], type: Int) {
        switch type {
        case 1:
            lblLanguage.text = arr.joined(separator: ",")
        case 2:
            txtAvailabity.text = arr.joined(separator: ",")
        default:
            break
        }
    }
}

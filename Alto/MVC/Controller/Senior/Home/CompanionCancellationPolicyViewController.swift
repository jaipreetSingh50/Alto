//
//  CompanionCancellationPolicyViewController.swift
//  Alto
//
//  Created by Jaypreet on 26/10/21.
//

import UIKit

protocol  CancelMeetingDelegate {
    func CancelMeetingStatus( viewType : Int , id : Int)
}


class CompanionCancellationPolicyViewController: UIViewController {
    var delegate : CancelMeetingDelegate!
    @IBOutlet weak var lblText: UILabel!
    var viewType : Int = 0
    var id : Int = 0

    @IBOutlet weak var btn: UIButton!
    @IBOutlet weak var lblTitle: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (Admin_Data != nil){
            if viewType == 0{
                if DataManager.CurrentUserRole == UserRole.Senior.get(){
                    lblText.text = Admin_Data.senior_cancel_policy
                }
                else{
                    lblText.text = Admin_Data.companion_cancel_policy
                }
            }
            if viewType == 1{
                lblText.text = Admin_Data.companion_cancel_policy
                lblTitle.text = "Accept Policy"
                btn.setTitle("Accept Meeting", for: .normal)

            }
            if viewType == -1{
                lblText.text = Admin_Data.companion_cancel_policy
                lblTitle.text = "Reject Policy"
                btn.setTitle("Reject Meeting", for: .normal)

            }
        }

        // Do any additional setup after loading the view.
    }
    @IBAction func Close(_ sender: Any) {
        dismiss(animated: false)
    }
    
    @IBAction func Cancel(_ sender: Any) {
        Dismiss(false) {
            self.delegate.CancelMeetingStatus(viewType : self.viewType, id: self.id)
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

//
//  CompanionFullDetailViewController.swift
//  Alto
//
//  Created by Jaypreet on 26/10/21.
//

import UIKit

class CompanionFullDetailViewController: UIViewController {

    @IBOutlet weak var lblType: UILabel!
    @IBOutlet weak var lblMeetingType: UILabel!
    @IBOutlet weak var lblContact: UIButton!
    @IBOutlet weak var lblTask: UILabel!
    @IBOutlet weak var lblRate: UILabel!
    @IBOutlet weak var lblExp: UILabel!
    @IBOutlet weak var lblDetail: UILabel!
    @IBOutlet weak var lblBookingID: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var imgCom: UIImageView!
    @IBOutlet weak var imgUser: UIImageView!
    
    var profileCom : M_User!
    var Com_Id : Int = 0
    var isRequest : Bool = false
    var Request : M_Request_Data!
    override func viewDidLoad() {
        super.viewDidLoad()
        lblName.text = ""
        lblBookingID.text = ""
        lblDetail.text = ""
        lblExp.text = ""
        lblTask.text = ""
        lblRate.text = ""
        imgUser.getImage(url: Constants.CurrentUserData.image ?? "")

        GetProfile()
       
        let underlineAttribute = [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.thick.rawValue]

        lblContact.setAttributedTitle(NSAttributedString.init(string: "Contact Alto " + "info@alto.cool", attributes: underlineAttribute), for: .normal)

        // Do any additional setup after loading the view.
    }
    
    func GetProfile()  {
        let dict = ["companion_id" : Com_Id,
                    ]
        
        APIClients.POST_user_companion_detail(parems: dict, storyBoard: storyboard!, navigation: self) { (result) in
            switch result {
            case .success(let response):
                print(response)

                self.profileCom = response.data
                self.SetProfileData()

            case .failure(let error):
                print(error)
            }
            
        } failure: { (error) in
            print(error)
        }
    }
    func SetProfileData()  {
        lblName.text = profileCom.full_name
        if isRequest {
            lblBookingID.text = "Booking #\(Request.id)"
        }
        lblDetail.text = profileCom.other_data?.bio
        imgCom.getImage(url: profileCom.image ?? "")
        imgUser.getImage(url: Constants.CurrentUserData.image ?? "")
        lblExp.text = profileCom.exp
        lblTask.text = profileCom.tasks
        lblRate.text = profileCom.rating
        lblMeetingType.text = profileCom.other_data?.language_speak
        if ((profileCom.other_data?.preferred_meeting ?? 3) == 3){
            lblType.text = AppMeetingType.FaceToFace.get() + ", " + AppMeetingType.Online.get()
        }
        if ((profileCom.other_data?.preferred_meeting ?? 3) == 1){
            lblType.text = AppMeetingType.Online.get()
        }
        if ((profileCom.other_data?.preferred_meeting ?? 3) == 2){
            lblType.text = AppMeetingType.FaceToFace.get()
        }
    }

    @IBAction func Back(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    @IBAction func MoreDetail(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(identifier: "CompanionOtherDetailViewController") as! CompanionOtherDetailViewController
        vc.profileCom = profileCom
        navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func viewReview(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(identifier: "SeniorReviewViewController") as! SeniorReviewViewController
        vc.User_id = profileCom.id
        vc.ViewType = 1

        present(vc, animated: true, completion: nil)
    }
    @IBAction func Call(_ sender: Any) {
        sendEmail()
        
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

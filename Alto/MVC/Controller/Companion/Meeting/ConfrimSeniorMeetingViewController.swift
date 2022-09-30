//
//  ConfrimSeniorMeetingViewController.swift
//  Alto
//
//  Created by Jaypreet on 01/11/21.
//

import UIKit

class ConfrimSeniorMeetingViewController: UIViewController {
    @IBOutlet weak var lblBooking: UILabel!
    
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var Gender: UILabel!
    @IBOutlet weak var lblAge: UILabel!
    @IBOutlet weak var lblContact: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var btnBook: UIButton!
    @IBOutlet weak var imgSen: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var btnCall: UIButton!
    @IBOutlet weak var imgUser: UIImageView!
    @IBOutlet weak var btnContact: UIButton!
    @IBOutlet weak var lblTitle: UILabel!
    var is_Request : Bool = false
    var Senior_Id : Int = 0
    var Request : M_Request_Data!
    var DatesArray = [[String : String]]()
    var profileCom : M_User!
    var Address : M_Address!
    
    var Tags : String = ""
    var Date : String = ""
    var Schdule : Int = 0
    var startTime : String = ""
    var EndTime : String = ""
    var Com_Id : Int = 0
    var selected_hrs : Int = 1
    var Language : String = ""
    var MeetingType : Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        if is_Request{
            btnBook.isHidden = true
            DatesArray = CommonFunctions().convertJSONToArray(arrayObject: Request.request_date) as! [[String : String]]


            lblTitle.text = "\(Request.senior_data?.last_name ?? "") is free to play \(Request.task) with you at your place."
            lblName.text = Request.senior_data?.full_name
            lblBooking.text = "Booking #\(Request.id)"
            lblEmail.text = Request.senior_data?.email
            lblAge.text = Request.senior_data?.dob?.getAge()
            lblContact.text = Request.senior_data?.phone
            lblAddress.text = "\(Request.address_data?.complete_address ?? ""), \(Request.address_data?.address ?? ""),\(Request.address_data?.city ?? ""),\n\(Request.address_data?.state ?? ""), \(Request.address_data?.country ?? ""),\(Request.address_data?.zip_code ?? "")"
            imgSen.getImage(url: Request.senior_data?.image ?? "")
            if Request.senior_data?.other_data?.gender == "1"{
                Gender.text = "Male"
            }
            else{
                Gender.text = "Female"
            }
            Senior_Id = Request.senior_data?.id ?? 0
        }
        else{
            GetProfile()
        }
        imgUser.getImage(url: Constants.CurrentUserData.image ?? "")
        if (Admin_Data != nil){
            let underlineAttribute = [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.thick.rawValue]

            btnContact.setAttributedTitle(NSAttributedString.init(string: "Contact Alto " + "info@alto.cool", attributes: underlineAttribute), for: .normal)
        }
        // Do any additional setup after loading the view.
    }
    func GetProfile()  {
        let dict = ["companion_id" : Senior_Id,
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
        btnBook.isHidden = false


        lblTitle.text = "\(profileCom.last_name ?? "") is free"
        lblName.text = profileCom.full_name
        lblBooking.text = ""
        lblEmail.text = profileCom.user_name
        lblAge.text = profileCom.dob?.getAge()
        lblContact.text = profileCom.phone
        
        
        
        lblAddress.text = "\(Address.complete_address ), \(Address.address),\(Address.city),\n\(Address.state), \(Address.country),\(Address.zip_code)"
        imgSen.getImage(url: profileCom.image ?? "")
        if profileCom.other_data?.gender == "1"{
            Gender.text = "Male"
        }
        else{
            Gender.text = "Female"
        }
    }
    @IBAction func viewReview(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(identifier: "SeniorReviewViewController") as! SeniorReviewViewController
        vc.User_id = Senior_Id
        vc.ViewType = 1

        navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func viewFullDetail(_ sender: Any) {
        
    }
    @IBAction func Back(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func Next(_ sender: Any) {
        if profileCom == nil{
            return
        }
        let rate : String = Admin_Data.hourly_rate

        let dict = ["task" : "-",
                    "request_date" : CommonFunctions().convertIntoJSONString(arrayObject: DatesArray)!,
                    "start_time" : "12:22",
                    "end_time" : "12:22",
                    "schedule" : Schdule,
                    "senior_id" : Senior_Id,
                    "address_id" : Address.id,
                    "cost" : rate
        ] as [String : Any]
        
        APIClients.POST_user_createRequest(parems: dict, storyBoard: storyboard!, navigation: self) { (result) in
            switch result {
            case .success(let response):
                print(response)
                let vc = self.storyboard?.instantiateViewController(identifier: "SeniorConfirmationViewController") as! SeniorConfirmationViewController
                vc.Request = response.data
                vc.Companion = self.profileCom
                vc.modalPresentationStyle = .overFullScreen
                self.present(vc, animated: false, completion: nil)


            case .failure(let error):
                print(error)
            }
            
        } failure: { (error) in
            print(error)
        }
        
        
        
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

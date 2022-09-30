//
//  CompanionProfileViewController.swift
//  Alto
//
//  Created by Jaypreet on 26/10/21.
//

import UIKit

class CompanionProfileViewController: UIViewController {

    @IBOutlet weak var lblMeetingType: UILabel!
    @IBOutlet weak var lblLanguages: UILabel!
    @IBOutlet weak var btnHrs3: UIButton!
    @IBOutlet weak var btnHrs2: UIButton!
    @IBOutlet weak var btnHrs1: UIButton!
    @IBOutlet weak var lblhrs: UILabel!
    @IBOutlet weak var lblInfo: UILabel!
    @IBOutlet weak var lblBookingNo: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var imgCom: UIImageView!
    @IBOutlet weak var imgUser: UIImageView!
    @IBOutlet weak var lblMeetingDetail: UILabel!
    
    @IBOutlet weak var lblhr1: UILabel!
    @IBOutlet weak var lblhr2: UILabel!
    @IBOutlet weak var lblhr3: UILabel!

    @IBOutlet weak var lblPrice1: UILabel!
    @IBOutlet weak var lblPrice2: UILabel!
    @IBOutlet weak var lblPrice3: UILabel!

    var profileCom : M_User!
    var DateArray = [[String : String]]()

    @IBOutlet weak var lblContact: UIButton!
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
        lblMeetingDetail.text = ""
        lblName.text = ""
        lblBookingNo.text = ""
        lblInfo.text = ""
        lblhr1.text = ""
        lblPrice1.text = ""
        lblhr2.text = ""
        lblPrice2.text = ""
        lblhr3.text = ""
        lblPrice3.text = ""
        lblhrs.text = ""
        GetProfile()
        imgUser.getImage(url: Constants.CurrentUserData.image ?? "")
        let underlineAttribute = [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.thick.rawValue]

        lblContact.setAttributedTitle(NSAttributedString.init(string: "Contact Alto " + "info@alto.cool", attributes: underlineAttribute), for: .normal)
        if (Admin_Data != nil){
            
            var totalHrs : Double = 0.0
            
            for i in DateArray{
                totalHrs += Double(self.GetTotalNumberOfHrs(days: i["date"]!, start: i["start_time"]!, end: i["end_time"]!))
            }
            
            
            
            lblhrs.text = "Total \(totalHrs) hrs : CHF " .ShowPrice(price: Double(Admin_Data.hourly_rate)! * totalHrs)
        }
        
        // Do any additional setup after loading the view.
    }
    @IBAction func Back(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    @IBAction func ViewProfile(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(identifier: "CompanionFullDetailViewController") as! CompanionFullDetailViewController
        vc.Com_Id = Com_Id
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func BookMeeting(_ sender: Any) {
        if MeetingType == AppMeetingType.Online.value(){
            CreateRequestApi(address_id : 0)
        }
        else{
            let vc = storyboard?.instantiateViewController(identifier: "AddressPopUpViewController") as! AddressPopUpViewController
            vc.modalPresentationStyle = .overFullScreen
            vc.delegate = self
            present(vc, animated: false, completion: nil)
        }
    }
    @IBAction func Call(_ sender: Any) {
        sendEmail()
    }
    @IBAction func SetTime(_ sender: UIButton) {
        selected_hrs = sender.tag
        switch sender.tag {
        case 1:
            btnHrs1.backgroundColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 0.3072150735)
            btnHrs2.backgroundColor = .clear
            btnHrs3.backgroundColor = .clear
        case 2:
            btnHrs1.backgroundColor = .clear
            btnHrs2.backgroundColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 0.3072150735)
            btnHrs3.backgroundColor = .clear
        case 3:
            btnHrs1.backgroundColor = .clear
            btnHrs2.backgroundColor = .clear
            btnHrs3.backgroundColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 0.3072150735)

        default:
            break
        }
        if profileCom == nil{
            return
        }
        
        var totalHrs = 0.0
        
        for i in DateArray{
            totalHrs += Double(self.GetTotalNumberOfHrs(days: i["date"]!, start: i["start_time"]!, end: i["end_time"]!))
        }
        
        
        
        lblhrs.text = "Total \(totalHrs) hrs : CHF " .ShowPrice(price: Double(Admin_Data.hourly_rate)! * totalHrs) 
       
    }
    func CreateRequestApi(address_id : Int)  {
        if profileCom == nil{
            return
        }
        var totalHrs = 0.0
        
        for i in DateArray{
            totalHrs += Double(self.GetTotalNumberOfHrs(days: i["date"]!, start: i["start_time"]!, end: i["end_time"]!))
        }
        let rate = Double(Admin_Data.hourly_rate)! * totalHrs

        let dict = ["task" : Tags,
                    "request_date" : CommonFunctions().convertIntoJSONString(arrayObject: DateArray)!,
                    "start_time" : "12:22",
                    "end_time" : "12:22",
                    "schedule" : Schdule,
                    "companion_id" : Com_Id,
                    "address_id" : address_id,
                    "cost" : rate,
                    "meeting_type" : MeetingType,
                    "meeting_lang" : Language
        ] as [String : Any]
        
        APIClients.POST_user_createRequest(parems: dict, storyBoard: storyboard!, navigation: self) { (result) in
            switch result {
            case .success(let response):
                print(response)
                let vc = self.storyboard?.instantiateViewController(identifier: "BookingConfirmationViewController") as! BookingConfirmationViewController
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
        lblMeetingDetail.text = "\(profileCom.full_name ?? "") is free to play \(Tags) with you at your place."
        lblName.text = profileCom.full_name
        lblBookingNo.text = ""
        lblInfo.text = profileCom.other_data?.bio
        btnHrs1.backgroundColor = .clear
        btnHrs2.backgroundColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 0.3072150735)
        btnHrs3.backgroundColor = .clear
        lblPrice2.text = "CHF ".ShowPrice(price: Double(Admin_Data.hourly_rate) ?? 0) + "/hr"
        lblhr2.text = "10 hr"
        lblLanguages.text = profileCom.other_data?.language_speak
        if ((profileCom.other_data?.preferred_meeting ?? 3) == 3){
            lblMeetingType.text = AppMeetingType.FaceToFace.get() + ", " + AppMeetingType.Online.get()
        }
        if ((profileCom.other_data?.preferred_meeting ?? 3) == 1){
            lblMeetingType.text = AppMeetingType.Online.get()
        }
        if ((profileCom.other_data?.preferred_meeting ?? 3) == 2){
            lblMeetingType.text = AppMeetingType.FaceToFace.get()
        }

        

        
//        lblhrs.text = "Total \(self.GetTotalNumberOfHrs(days: Date, start: startTime, end: EndTime)) hrs : CHF ".ShowPrice(price: Double(Admin_Data.hourly_rate) ?? 0) + "/hr"
//        let hrs = CommonFunctions().convertJSONToArray(arrayObject: profileCom.other_data?.hourly_rate ?? "")
//        if hrs.count == 3{
//            let hrs1 = hrs[0]
//            lblhr1.text = "\(hrs1["hrs"] ?? 0)"
//            lblPrice1.text = "CHF \(hrs1["rate"] ?? 0)/hr"
//
//            let hrs2 = hrs[1]
//
//            lblhr2.text = "\(hrs2["hrs"] ?? 0)"
//            lblPrice2.text = "CHF \(hrs2["rate"] ?? 0)/hr"
//
//            let hrs3 = hrs[2]
//
//            lblhr3.text = "\(hrs3["hrs"] ?? 0)"
//            lblPrice3.text = "CHF \(hrs3["rate"] ?? 0)/hr"
//            btnHrs1.backgroundColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 0.3072150735)
//            btnHrs2.backgroundColor = .clear
//            btnHrs3.backgroundColor = .clear
//
//            lblhrs.text = "Total 1 hr : CHF \(hrs1["rate"] ?? 0)/hr"
//
//        }
        
        
        
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
extension CompanionProfileViewController : AddressPopupDelegate{
    func SelectAddress(id: Int) {
        CreateRequestApi(address_id: id)
    }
    
    func SelectNewAddress() {
        let vc = self.storyboard?.instantiateViewController(identifier: "SeniorSignup3ViewController") as! SeniorSignup3ViewController
        vc.modalPresentationStyle = .fullScreen
        vc.isNewAddress = true
        self.present(vc, animated: true, completion: nil)

    }
    
    
}

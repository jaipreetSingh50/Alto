//
//  BookingDetailViewController.swift
//  Alto
//
//  Created by Jaypreet on 29/10/21.
//

import UIKit

class BookingDetailViewController: UIViewController {
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    
    @IBOutlet weak var viewAddress: UIView!
    @IBOutlet weak var lblType: UILabel!
    @IBOutlet weak var lblLanguage: UILabel!
    @IBOutlet weak var c_table_h: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var btnConfirmed: UIButton!
    @IBOutlet weak var btnTrack: UIButton!
    @IBOutlet weak var lbltitle: UILabel!
    @IBOutlet weak var imgUser: UIImageView!
    @IBOutlet weak var lblBookingNo: UILabel!
    @IBOutlet weak var lblCost: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var btnCabcel: UIButton!
    @IBOutlet weak var btnComplete: UIButton!
    @IBOutlet weak var btnStart: UIButton!
    @IBOutlet weak var imgtitleUser: UIImageView!
    var viewType : Int = 1
    var Request : M_Request_Data!
    var DatesArray = [[String : String]]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        tableView.RegisterTableCell("ShowTimeTableViewCell")
        
        
  
        SetRequestView()
        // Do any additional setup after loading the view.
    }
    func SetRequestView()  {
        
        switch Request.status {
        case RequestStatus.New.get() , RequestStatus.CancelledBySenior.get() , RequestStatus.CancelledByComapnion.get() , RequestStatus.Completed.get() :
            btnStart.isHidden = true
            btnComplete.isHidden = true
            btnCabcel.isHidden = true
            btnTrack.isHidden = false
            btnConfirmed.isHidden = true

            
        case RequestStatus.Accepted.get():
            btnConfirmed.isHidden = false

            btnStart.isHidden = true
            btnComplete.isHidden = true
            btnCabcel.isHidden = false
            btnTrack.isHidden = false
        case RequestStatus.Confirmed.get():
            btnStart.isHidden = false
            btnComplete.isHidden = true
            btnCabcel.isHidden = false
            btnTrack.isHidden = false
            btnConfirmed.isHidden = true

        case RequestStatus.Started.get():
            btnStart.isHidden = true
            btnComplete.isHidden = false
            btnCabcel.isHidden = true
            btnTrack.isHidden = false
            btnConfirmed.isHidden = true
            
            if Request.meeting_type == AppMeetingType.Online.value(){
                btnTrack.isHidden = true
                btnStart.isHidden = false

            }

        default:
            btnStart.isHidden = true
            btnComplete.isHidden = true
            btnCabcel.isHidden = true
            btnTrack.isHidden = true
            btnConfirmed.isHidden = true

            break
        }
        lblName.text = Request.senior_data?.full_name
        lblBookingNo.text = "BOOKING #\(Request.id)"
        
        DatesArray = CommonFunctions().convertJSONToArray(arrayObject: Request.request_date) as! [[String : String]]
        c_table_h.constant = CGFloat(40 * DatesArray.count)
        tableView.reloadData()

        var totalHrs = 0.0
        
        for i in DatesArray{
            totalHrs += Double(self.GetTotalNumberOfHrs(days: i["date"]!, start: i["start_time"]!, end: i["end_time"]!))
        }
        
        if DatesArray.count != 0{
            let arr = DatesArray[0]
            let time = arr["date"]! + " " + arr["start_time"]!

            lblTime.text = time.getTimeLeft(format: "dd/MM/yyyy HH:mm")
        }
        
        
        
            let price = Double(Request.cost)! -  (Double(Request.cost)! * 20)/100

        
            lblCost.text = "Total \(totalHrs) hrs : CHF " .ShowPrice(price: price)
        

        lbltitle.text = "\(Request.senior_data?.last_name ?? "") is free for \(GetMeetingTypeString(type: Request.meeting_type ?? 2)) meeting"
        
        
        imgUser.getImage(url: Request.senior_data?.image ?? "")
        lblAddress.text = "\(Request.address_data?.complete_address ?? ""),\(Request.address_data?.address ?? ""),\n\(Request.address_data?.city ?? ""), \(Request.address_data?.state ?? ""), \(Request.address_data?.country ?? ""),\n\(Request.address_data?.zip_code ?? "")"
        lblLanguage.text = Request.meeting_lang
        lblType.text = Request.task
        if Request.meeting_type == AppMeetingType.Online.value(){
            viewAddress.isHidden = true
            btnTrack.isHidden = true

        }
    }
    @IBAction func CallSenior(_ sender: Any) {
        if (Request.senior_data?.phone != nil){
            self.CallOnPhone(number: Request.senior_data?.phone ?? "")
        }
    }
    @IBAction func ViewFullProfile(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(identifier: "ConfrimSeniorMeetingViewController") as! ConfrimSeniorMeetingViewController
        vc.Senior_Id = Request.senior_data!.id
        vc.is_Request = true
        vc.Request = Request
        navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func Back(_ sender: Any) {
        Dismiss()
    }
    @IBAction func Confirmed(_ sender: Any) {
        ChangeMeetingStatus(id: Request.id, status: RequestStatus.Confirmed.get())

    }
    @IBAction func Track(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(identifier: "TrackCompanionViewController") as! TrackCompanionViewController
        vc.Request = Request
        navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func Cancel(_ sender: Any) {
        
        let vc = storyboard?.instantiateViewController(identifier: "CompanionCancellationPolicyViewController") as! CompanionCancellationPolicyViewController
        vc.delegate = self
        vc.modalPresentationStyle = .overFullScreen
        present(vc, animated: false, completion: nil)

        
    }
    @IBAction func Start(_ sender: Any) {
        if Request.meeting_type == AppMeetingType.Online.value(){
            GetVideoCall { (sessionId, Token) in
                self.SendCallNotification(sessionId: sessionId, Token: Token)
            }
        }
        else{
            ChangeMeetingStatus(id: Request.id, status: RequestStatus.Started.get())
        }
    }
    @IBAction func Complete(_ sender: Any) {
        ChangeMeetingStatus(id: Request.id, status: RequestStatus.Completed.get())
    }
    func ChangeMeetingStatus(id : Int , status : Int)  {
        let dict = ["meeting_id" : id,
                    "status" : status
                    ]
        
        APIClients.POST_user_meetingStatusChange(parems: dict, storyBoard: storyboard!, navigation: self) { (result) in
            switch result {
            case .success(let response):
                print(response)
                self.Request.status = status
                self.SetRequestView()
                if RequestStatus.Completed.get() == status{
                    let vc = self.storyboard?.instantiateViewController(identifier: "GiveReviewViewController") as! GiveReviewViewController

                    vc.Request = self.Request
                    self.navigationController?.pushViewController(vc, animated: true)
                }

            case .failure(let error):
                print(error)
            }
            
        } failure: { (error) in
            print(error)
        }
    }
    func SendCallNotification(sessionId : String , Token : String)  {
        let dict = ["friend_id" : Request.senior_data?.id ?? 0,
                    "sessionid" : sessionId,
                    "opentoktoken" : Token,
                    "type" : 4,
                    "request_id" : Request.id

        ] as [String : Any]
        
        APIClients.POST_user_opentok_notification(parems: dict, storyBoard: storyboard!, navigation: self) { (result) in
            switch result {
            case .success(let response):
                print(response)
                    let vc = self.storyboard?.instantiateViewController(identifier: "VideoCallViewController") as! VideoCallViewController
                    vc.modalPresentationStyle = .fullScreen
                    vc.Request = self.Request
                vc.kToken = Token
                vc.kSessionId = sessionId
                vc.Request_id = self.Request.id
                    self.present(vc, animated: true, completion: nil)
//                    self.navigationController?.pushViewController(vc, animated: true)
                

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
extension BookingDetailViewController : UITableViewDelegate , UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DatesArray.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ShowTimeTableViewCell", for: indexPath) as! ShowTimeTableViewCell
        cell.selectionStyle = .none
        let dates = DatesArray[indexPath.row]
        cell.lblDate.text = "\(dates["date"] ?? "")".getTimeFromTime(currentFormat: DateFormat.dd_MM_yyyy.get(), requiredFormat: DateFormat.dd_MMM_yyyy.get())

        cell.lblTime.text = "\((dates["date"]! + " " + dates["start_time"]!).getTime(format: "hh:mm a")) to \((dates["date"]! + " " + dates["end_time"]!).getTime(format: "hh:mm a"))"
                            
        return cell
    }
   
}
extension BookingDetailViewController : CancelMeetingDelegate{
    func CancelMeetingStatus(viewType : Int , id  : Int)  {
                let vc = storyboard?.instantiateViewController(identifier: "BookingCancelViewController") as! BookingCancelViewController
                vc.Request = Request
                navigationController?.pushViewController(vc, animated: true)
        
    }
}

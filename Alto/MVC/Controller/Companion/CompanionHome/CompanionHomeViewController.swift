//
//  CompanionHomeViewController.swift
//  Alto
//
//  Created by Jaypreet on 29/10/21.
//

import UIKit
import CoreLocation

class CompanionHomeViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var imgUser: UIImageView!
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var underUpcoming: UILabel!
    @IBOutlet weak var lblUpcoming: UILabel!
    @IBOutlet weak var underCompleted: UILabel!
    @IBOutlet weak var lblCompleted: UILabel!
    @IBOutlet weak var underCancelled: UILabel!
    @IBOutlet weak var lblCancelled: UILabel!
    @IBOutlet weak var underNew: UILabel!
    @IBOutlet weak var lblNew: UILabel!

    var ListType : Int = 1
    var CollectionMeeting = [M_Request_Data]()
    let locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Ask for Authorisation from the User.
        self.locationManager.requestAlwaysAuthorization()

        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()

        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        tableView.RegisterTableCell("NewBookingTableViewCell")
       
        lblName.text = Constants.CurrentUserData.full_name
        imgUser.getImage(url: Constants.CurrentUserData.image ?? "")
        self.GetAdminDATA { (data) in
            print(data)
        }
        NotificationCenter.default.addObserver(self, selector: #selector(ReloadScreen), name:  NSNotification.Name.init("NotificationgetNoti"), object: [:])
        if Constants.CurrentUserData.connect_id == ""{
            AskPayment()
        }
        // Do any additional setup after loading the view.
    }
    func AskPayment()  {
        let alert = UIAlertController.init(title: "Payment Alert!", message: "Please connect your payment details in Payment from Setting.", preferredStyle: .alert)
        let add = UIAlertAction.init(title: "Add", style: .default) { act in
            self.OpenPaymentScreen()
        }
        alert.addAction(add)
        let Skip = UIAlertAction.init(title: "Skip", style: .cancel) { act in
            
        }
        alert.addAction(Skip)
        present(alert, animated: true, completion: nil)
    }
    func OpenPaymentScreen()  {
        let vc = storyboard?.instantiateViewController(identifier: "AddCardViewController") as! AddCardViewController
        let navi = UINavigationController.init(rootViewController: vc)
        navi.modalPresentationStyle = .fullScreen
        navi.isNavigationBarHidden = true

        present(navi, animated: true, completion: nil)
    }
    @objc func ReloadScreen()  {
        GetMeetingList(type : ListType)

    }
    override func viewWillAppear(_ animated: Bool) {
        SetHeaderView(type: ListType)
    }
    @IBAction func Calendar(_ sender: Any) {
        let dayViewController = CustomCalendarExampleController()
        let navigation = UINavigationController(rootViewController: dayViewController)
        present(navigation, animated: true, completion: nil)
    }
    @IBAction func Notification(_ sender: Any) {
       let vc = storyboard?.instantiateViewController(withIdentifier: "NotificationListViewController") as! NotificationListViewController
        present(vc, animated: true, completion: nil)
    }
    @IBAction func ListType(_ sender: UIButton) {
        SetHeaderView(type: sender.tag)
    }
    func SetHeaderView(type : Int)  {

        ListType = type
        switch type {
        case 1:
            underNew.backgroundColor = #colorLiteral(red: 0.4784313725, green: 0.9058823529, blue: 0.7803921569, alpha: 1)
            underUpcoming.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            underCompleted.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            underCancelled.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            lblNew.textColor = #colorLiteral(red: 0.4784313725, green: 0.9058823529, blue: 0.7803921569, alpha: 1)
            lblUpcoming.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            lblCompleted.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            lblCancelled.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            GetMeetingList(type : 0)
        case 2:
            underNew.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            lblNew.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            underUpcoming.backgroundColor = #colorLiteral(red: 0.4784313725, green: 0.9058823529, blue: 0.7803921569, alpha: 1)
            underCompleted.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            underCancelled.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            lblUpcoming.textColor = #colorLiteral(red: 0.4784313725, green: 0.9058823529, blue: 0.7803921569, alpha: 1)
            lblCompleted.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            lblCancelled.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            GetMeetingList(type : 1)
        case 3:
            underNew.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            lblNew.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            underUpcoming.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            underCompleted.backgroundColor = #colorLiteral(red: 0.4784313725, green: 0.9058823529, blue: 0.7803921569, alpha: 1)
            underCancelled.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            lblUpcoming.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            lblCompleted.textColor = #colorLiteral(red: 0.4784313725, green: 0.9058823529, blue: 0.7803921569, alpha: 1)
            lblCancelled.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            GetMeetingList(type : 2)
        case 4:
            underNew.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            lblNew.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            underUpcoming.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            underCompleted.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            underCancelled.backgroundColor = #colorLiteral(red: 0.4784313725, green: 0.9058823529, blue: 0.7803921569, alpha: 1)
            lblUpcoming.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            lblCompleted.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            lblCancelled.textColor = #colorLiteral(red: 0.4784313725, green: 0.9058823529, blue: 0.7803921569, alpha: 1)
            GetMeetingList(type : 3)



        default:
            break
        }
    }
    func GetMeetingList(type : Int)  {
        let dict = ["type" : type,
                    ]
        
        APIClients.POST_user_meetingCompanionList(parems: dict, storyBoard: storyboard!, navigation: self) { (result) in
            switch result {
            case .success(let response):
                print(response)
                self.CollectionMeeting = response.data
                self.tableView.reloadData()

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
extension CompanionHomeViewController : UITableViewDelegate , UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CollectionMeeting.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewBookingTableViewCell", for: indexPath) as! NewBookingTableViewCell

        cell.lblTypeName.text = self.GetMeetingTypeString(type: CollectionMeeting[indexPath.row].meeting_type ?? 2)
//        cell.lblTime.text = "\(CollectionMeeting[indexPath.row].address_data?.address ?? ""), \(CollectionMeeting[indexPath.row].address_data?.city ?? ""), \(CollectionMeeting[indexPath.row].address_data?.state ?? ""), \(CollectionMeeting[indexPath.row].address_data?.country ?? ""), \(CollectionMeeting[indexPath.row].address_data?.zip_code ?? "")"
        let price = Double(CollectionMeeting[indexPath.row].cost)! -  (Double(CollectionMeeting[indexPath.row].cost)! * 20)/100
        cell.lblCost.text = "CHF \(price)"
        
        cell.lblName.text = CollectionMeeting[indexPath.row].senior_data?.full_name
        cell.imgUser.getImage(url: CollectionMeeting[indexPath.row].companion_data?.image ?? "")
        cell.lblBookingNo.text = "Booking #\(CollectionMeeting[indexPath.row].id)"
        cell.btnAccept.addTarget(self, action: #selector(Accept(_:)), for: .touchDown)
        cell.btnAccept.tag = indexPath.row
        cell.btnReject.addTarget(self, action: #selector(Reject(_:)), for: .touchDown)
        cell.btnReject.tag = indexPath.row
       let DatesArray = CommonFunctions().convertJSONToArray(arrayObject: CollectionMeeting[indexPath.row].request_date) as! [[String : String]]
        if DatesArray.count != 0{
            let arr = DatesArray[0]
            cell.lblTime.text = "\(arr["date"]!.getTimeFromTime(currentFormat: DateFormat.dd_MM_yyyy.get(), requiredFormat: DateFormat.dd_MMM_yyyy.get())) \(arr["start_time"]!)"
        }
        
        switch CollectionMeeting[indexPath.row].status {
        case RequestStatus.New.get():
            cell.selectionStyle = .none
            cell.lblStatus.isHidden = false
            cell.btnReject.isHidden = false
            cell.btnAccept.isHidden = false
            cell.lblStatus.text = "New Meeting (Response time : \(CollectionMeeting[indexPath.row].created_at.getTimeLeftFrom(format: "yyyy-MM-dd HH:mm:ss")))"
            cell.lblStatus.textColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
        case RequestStatus.Accepted.get():
            cell.selectionStyle = .none
            cell.lblStatus.isHidden = false
            cell.btnReject.isHidden = true
            cell.btnAccept.isHidden = true
            cell.lblStatus.text = "Waiting For Conformation (Response time : \(CollectionMeeting[indexPath.row].created_at.getTimeLeftFrom(format: "yyyy-MM-dd HH:mm:ss")))"
            cell.lblStatus.textColor = #colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)

        case RequestStatus.Confirmed.get():
            cell.selectionStyle = .none
            cell.lblStatus.isHidden = false
            cell.btnReject.isHidden = true
            cell.btnAccept.isHidden = true
            cell.lblStatus.text = "Confirmed"
            cell.lblStatus.textColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
        case RequestStatus.Started.get():
            cell.selectionStyle = .none
            cell.lblStatus.isHidden = false
            cell.btnReject.isHidden = true
            cell.btnAccept.isHidden = true
            cell.lblStatus.text = "Started"
            cell.lblStatus.textColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)

        case RequestStatus.Completed.get():
            cell.selectionStyle = .none
            cell.lblStatus.isHidden = false
            cell.btnReject.isHidden = true
            cell.btnAccept.isHidden = true
            cell.lblStatus.text = "Completed"
            cell.lblStatus.textColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)

        default:
            cell.selectionStyle = .none
            cell.lblStatus.isHidden = false
            cell.lblStatus.text = "Cancelled"
            cell.btnReject.isHidden = true
            cell.btnAccept.isHidden = true
            cell.lblStatus.textColor = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)

        }
        return cell

    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(identifier: "BookingDetailViewController") as! BookingDetailViewController
        vc.Request = CollectionMeeting[indexPath.row]
        let navi = UINavigationController.init(rootViewController: vc)
        navi.modalPresentationStyle = .fullScreen
        navi.isNavigationBarHidden = true
        present(navi, animated: true, completion: nil)
    }
    @IBAction func Accept(_ sender: UIButton) {
        
        let vc = storyboard?.instantiateViewController(identifier: "CompanionCancellationPolicyViewController") as! CompanionCancellationPolicyViewController
        vc.delegate = self
        vc.viewType = 1
        vc.id = CollectionMeeting[sender.tag].id

        vc.modalPresentationStyle = .overFullScreen
        present(vc, animated: false, completion: nil)
        
    }
    @IBAction func Reject(_ sender: UIButton) {
        let vc = storyboard?.instantiateViewController(identifier: "CompanionCancellationPolicyViewController") as! CompanionCancellationPolicyViewController
        vc.delegate = self
        vc.viewType = -1
        vc.id = CollectionMeeting[sender.tag].id
        vc.modalPresentationStyle = .overFullScreen
        present(vc, animated: false, completion: nil)

    }
    func ChangeMeetingStatus(id : Int , status : Int)  {
        let dict = ["meeting_id" : id,
                    "status" : status
                    ]
        
        APIClients.POST_user_meetingStatusChange(parems: dict, storyBoard: storyboard!, navigation: self) { (result) in
            switch result {
            case .success(let response):
                print(response)

                self.SetHeaderView(type: self.ListType)

            case .failure(let error):
                print(error)
            }
            
        } failure: { (error) in
            print(error)
        }
    }
}
extension CompanionHomeViewController : CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let _ : CLLocationCoordinate2D = manager.location?.coordinate else { return }

        
        let locValue: CLLocationCoordinate2D = manager.location!.coordinate
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        Current_lat = "\(locValue.latitude)"
        Current_lng = "\(locValue.longitude)"
        self.UpdateProfile()
        locationManager.stopUpdatingLocation()

    }
}
extension CompanionHomeViewController : CancelMeetingDelegate{
    func CancelMeetingStatus(viewType : Int , id : Int)  {
              
        ChangeMeetingStatus(id: id, status: viewType)

    }
}

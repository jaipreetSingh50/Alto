//
//  HomeSeniorViewController.swift
//  Alto
//
//  Created by Jaypreet on 26/10/21.
//

import UIKit
import CoreLocation

class HomeSeniorViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var imgUser: UIImageView!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var underUpcoming: UILabel!
    @IBOutlet weak var lblUpcoming: UILabel!
    @IBOutlet weak var underCompleted: UILabel!
    @IBOutlet weak var lblCompleted: UILabel!
    @IBOutlet weak var underCancelled: UILabel!
    @IBOutlet weak var lblCancelled: UILabel!
    var CollectionMeeting = [M_Request_Data]()
    let locationManager = CLLocationManager()
    var SelectedCat : Int = 1

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.RegisterTableCell("MeetingTableViewCell")
  
        lblUserName.text = Constants.CurrentUserData.full_name
        imgUser.getImage(url: Constants.CurrentUserData.image ?? "")
        // Ask for Authorisation from the User.
        self.locationManager.requestAlwaysAuthorization()

        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()

        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }

        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self, selector: #selector(UploadProfile), name: Notification.Name.NotificationUpdateProfile, object: [:])
        
        self.GetAdminDATA { (data) in
            print(data)
        }
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(ReloadScreen), name:  NSNotification.Name.init("NotificationgetNoti"), object: [:])
        // Do any additional setup after loading the view.
    }
    @objc func ReloadScreen()  {
        GetMeetingList(type : SelectedCat)

    }
    
    @objc func UploadProfile()  {
        imgUser.getImage(url: Constants.CurrentUserData.image ?? "")
       
    }
    @IBAction func Calender(_ sender: Any) {
        let dayViewController = CustomCalendarExampleController()
        let navigation = UINavigationController(rootViewController: dayViewController)
        present(navigation, animated: true, completion: nil)
    }
    @IBAction func NotificationList(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "NotificationListViewController") as! NotificationListViewController
        present(vc, animated: true, completion: nil)
    }
    override func viewDidAppear(_ animated: Bool) {
        SetHeaderView(type: SelectedCat)

    }
    @IBAction func ListType(_ sender: UIButton) {
        SetHeaderView(type: sender.tag)
    }
    func SetHeaderView(type : Int)  {
        
        SelectedCat = type
        GetMeetingList(type: type)
        switch type {
        case 1:
            underUpcoming.backgroundColor = #colorLiteral(red: 0.4784313725, green: 0.9058823529, blue: 0.7803921569, alpha: 1)
            underCompleted.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            underCancelled.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            lblUpcoming.textColor = #colorLiteral(red: 0.4784313725, green: 0.9058823529, blue: 0.7803921569, alpha: 1)
            lblCompleted.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            lblCancelled.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        case 2:
            underUpcoming.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            underCompleted.backgroundColor = #colorLiteral(red: 0.4784313725, green: 0.9058823529, blue: 0.7803921569, alpha: 1)
            underCancelled.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            lblUpcoming.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            lblCompleted.textColor = #colorLiteral(red: 0.4784313725, green: 0.9058823529, blue: 0.7803921569, alpha: 1)
            lblCancelled.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)

        case 3:
            underUpcoming.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            underCompleted.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            underCancelled.backgroundColor = #colorLiteral(red: 0.4784313725, green: 0.9058823529, blue: 0.7803921569, alpha: 1)
            lblUpcoming.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            lblCompleted.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            lblCancelled.textColor = #colorLiteral(red: 0.4784313725, green: 0.9058823529, blue: 0.7803921569, alpha: 1)
        default:
            break
        }
    }
    func GetMeetingList(type : Int)  {
        let dict = ["type" : type,
                    ]
        
        APIClients.POST_user_meetingSeniorList(parems: dict, storyBoard: storyboard!, navigation: self) { (result) in
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
extension HomeSeniorViewController : UITableViewDelegate , UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CollectionMeeting.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MeetingTableViewCell", for: indexPath) as! MeetingTableViewCell
        cell.selectionStyle = .none
        cell.btnChat.isHidden = true
        cell.lblName.text = CollectionMeeting[indexPath.row].companion_data?.full_name
        cell.imgUser.getImage(url: CollectionMeeting[indexPath.row].companion_data?.image ?? "")
        cell.lblType.text = self.GetMeetingTypeString(type: CollectionMeeting[indexPath.row].meeting_type ?? 2) 
        
        cell.lblBooking.text = "Booking #\(CollectionMeeting[indexPath.row].id)"
        cell.lblHrs.text = "CHF \(CollectionMeeting[indexPath.row].cost)/hr"
 
        let DatesArray = CommonFunctions().convertJSONToArray(arrayObject: CollectionMeeting[indexPath.row].request_date) as! [[String : String]]
         if DatesArray.count != 0{
             let arr = DatesArray[0]
             cell.lblDate.text = "\(arr["date"]!.getTimeFromTime(currentFormat: DateFormat.dd_MM_yyyy.get(), requiredFormat: DateFormat.dd_MMM_yyyy.get())) \(arr["start_time"]!)"
         }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(identifier: "CompanionDetailViewController") as! CompanionDetailViewController
        let navi = UINavigationController.init(rootViewController: vc)
        navi.modalPresentationStyle = .fullScreen
        navi.isNavigationBarHidden = true
        vc.Request = CollectionMeeting[indexPath.row]
        present(navi, animated: true, completion: nil)
    }
}
extension HomeSeniorViewController : CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        Current_lat = "\(locValue.latitude)"
        Current_lng = "\(locValue.longitude)"
        self.UpdateProfile()
        locationManager.stopUpdatingLocation()

    }
}

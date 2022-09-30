//
//  MeetingTimeViewController.swift
//  Alto
//
//  Created by Jaypreet on 26/10/21.
//

import UIKit

class MeetingTimeViewController: UIViewController {


    @IBOutlet weak var imgUser: UIImageView!
    
    var Tags : String = ""
    var Dates : String = ""
    var Date_for : Date!
    var DateArray = [[String : String]]()
    var Schdule : Int = 0
    var Language : String = ""
    var MeetingType : Int = 0
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imgUser.getImage(url: Constants.CurrentUserData.image ?? "")
        if Date_for.get(.day) == Date().get(.day){
//            startDatePicker.minimumDate = Foundation.Date()
        }
        tableView.RegisterTableCell("SetTimeTableViewCell")
        let dates = Dates.components(separatedBy: ",")
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm"

        for i in dates{
            let date = ["date" : i,
                        "start_time" : formatter.string(from: Date()),
                        "end_time" : formatter.string(from: Date().addingTimeInterval(3600))]
            DateArray.append(date)
        }
        
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func Back(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    @IBAction func Continue(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(identifier: "PeopleNearByViewController") as! PeopleNearByViewController
        vc.Tags = Tags
        vc.Date = Dates
        vc.DateArray = DateArray
        vc.Language = Language
        vc.MeetingType = MeetingType
        navigationController?.pushViewController(vc, animated: true)
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
extension MeetingTimeViewController : UITableViewDelegate , UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DateArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SetTimeTableViewCell", for: indexPath) as! SetTimeTableViewCell
        cell.selectionStyle = .none
        let dates = DateArray[indexPath.row]
        cell.lblMeetingDate.text = "Meeting Date : \(dates["date"] ?? "")"
        cell.startTime.addTarget(self, action: #selector(self.StartTime(sender:)), for: .valueChanged)
        cell.startTime.tag = indexPath.row
        cell.endTime.addTarget(self, action: #selector(self.EndTime(sender:)), for: .valueChanged)
        cell.endTime.tag = indexPath.row
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        cell.startTime.date = formatter.date(from: dates["start_time"]!)!
        cell.endTime.date = formatter.date(from: dates["end_time"]!)!
        cell.startTime.locale = NSLocale(localeIdentifier: "en_GB") as Locale
        cell.endTime.locale = NSLocale(localeIdentifier: "en_GB") as Locale
            
        return cell
    }
    @objc func StartTime(sender : UIDatePicker) {
        let cell = tableView.cellForRow(at: IndexPath.init(row: sender.tag, section: 0)) as! SetTimeTableViewCell

        cell.endTime.minimumDate = sender.date.addingTimeInterval(60 * 60)
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        sender.locale = NSLocale(localeIdentifier: "en_GB") as Locale

        DateArray[sender.tag]["start_time"] = formatter.string(from: sender.date)
        DateArray[sender.tag]["end_time"] = formatter.string(from: sender.date.addingTimeInterval(60 * 60))

//        tableView.reloadRows(at: [IndexPath.init(row: sender.tag, section: 0)], with: .none)
    }
    @objc func EndTime(sender : UIDatePicker) {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        sender.locale = NSLocale(localeIdentifier: "en_GB") as Locale

        DateArray[sender.tag]["end_time"] = formatter.string(from: sender.date)
    }
}

//
//  CompanionAddMeetingViewController.swift
//  Alto
//
//  Created by Jaypreet on 29/10/21.
//

import UIKit
import Koyomi

class CompanionAddMeetingViewController: UIViewController ,KoyomiDelegate{

   
    @IBOutlet weak var imgUser: UIImageView!
    @IBOutlet weak var viewDates: Koyomi!
    @IBOutlet weak var sgtMonth: UISegmentedControl!
    var Tags : String = ""

    @IBOutlet weak var lblMonth: UILabel!
    var SelectedDates : [String] = []

    var Date : String = ""
    var Date_for : Date!
    var DateArray = [[String : String]]()
    var Schdule : Int = 0

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.RegisterTableCell("SetTimeTableViewCell")
 


        viewDates.isHiddenOtherMonth = true
        viewDates.isMultipleTouchEnabled = false
        viewDates.selectionMode = .multiple(style: .circle)
        viewDates.calendarDelegate = self
        viewDates.display(in: .current)
        lblMonth.text = viewDates.currentDateString()
//        viewDates.weeks = ( "Mon", "Tue", "Wed", "Thu", "Fri", "Sat","Sun")

        
        sgtMonth.selectedSegmentIndex = 1

        viewDates.style = .standard
        
        
        
        // Do any additional setup after loading the view.
    }
    @IBAction func SgtMonth(_ sender: UISegmentedControl) {
        let month: MonthType = {
            switch sender.selectedSegmentIndex {
            case 0:  return .previous
            case 1:  return .current
            default: return .next
            }
        }()
        viewDates.display(in: month)
        lblMonth.text = viewDates.currentDateString()

    }
    @IBAction func Continue(_ sender: Any) {
//        let vc = storyboard?.instantiateViewController(identifier: "ConfrimSeniorMeetingViewController") as! ConfrimSeniorMeetingViewController
//
//        let navi = UINavigationController.init(rootViewController: vc)
//        navi.modalPresentationStyle = .fullScreen
//        navi.isNavigationBarHidden = true
//
//        present(navi, animated: true, completion: nil)
        
        
        
        let vc = storyboard?.instantiateViewController(identifier: "PeopleNearByViewController") as! PeopleNearByViewController
        vc.Tags = Tags
        vc.Date = Date
        vc.DateArray = DateArray

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
extension CompanionAddMeetingViewController : UITableViewDelegate , UITableViewDataSource{
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
        cell.startTime.date = formatter.date(from: dates["start_time"]!) ?? Foundation.Date()
        cell.endTime.date = formatter.date(from: dates["end_time"]!) ?? Foundation.Date()

        
        return cell
    }
    @objc func StartTime(sender : UIDatePicker) {
        let cell = tableView.cellForRow(at: IndexPath.init(row: sender.tag, section: 0)) as! SetTimeTableViewCell
        cell.endTime.minimumDate = sender.date.addingTimeInterval(3600)
        
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        DateArray[sender.tag]["start_time"] = formatter.string(from: sender.date)
        tableView.reloadData()
    }
    @objc func EndTime(sender : UIDatePicker) {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        DateArray[sender.tag]["end_time"] = formatter.string(from: sender.date)
    }
}
extension CompanionAddMeetingViewController{
    func koyomi(_ koyomi: Koyomi, didSelect date: Date?, forItemAt indexPath: IndexPath) {
        let dateFormatter = DateFormatter()
//        dateFormatter.timeZone = TimeZone(identifier: timeZone)
        dateFormatter.locale = Locale(identifier: LocationCode)
        dateFormatter.dateFormat =  DateFormat.dd_MM_yyyy.get()
        let selectedDate = dateFormatter.string(from: date!)
//        print(selectedDate)
        if SelectedDates.contains(selectedDate){
            SelectedDates.remove(at: SelectedDates.firstIndex(where: { ($0 == selectedDate)}) ?? 0)
            DateArray.remove(at: SelectedDates.firstIndex(where: { ($0 == selectedDate)}) ?? 0)
        }
        else{
            SelectedDates.append(selectedDate)
            
            let formatter = DateFormatter()
            formatter.dateFormat = "HH:mm"
            
            let date = ["date" : selectedDate,
                        "start_time" : formatter.string(from: Foundation.Date()),
                        "end_time" : formatter.string(from: Foundation.Date().addingTimeInterval(3600))]
            DateArray.append(date)
        }
       
        tableView.reloadData()
    }
    func koyomi(_ koyomi: Koyomi, shouldSelectDates date: Date?, to toDate: Date?, withPeriodLength length: Int) -> Bool {
        let dateFormatter = DateFormatter()
//        dateFormatter.timeZone = TimeZone(identifier: timeZone)
        dateFormatter.locale = Locale(identifier: LocationCode)
        dateFormatter.dateFormat =  DateFormat.dd_MM_yyyy.get()
        let selectedDate = dateFormatter.string(from: date!)
        let toDate = dateFormatter.string(from: toDate ?? Foundation.Date())
        let today = dateFormatter.string(from: Foundation.Date())

        print(selectedDate)
        print(toDate)
        
        
        if selectedDate == today{
            return true
        }
        if date! < Foundation.Date(){
            return false
        }
        return true
    }
}

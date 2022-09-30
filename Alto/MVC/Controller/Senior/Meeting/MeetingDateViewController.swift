//
//  MeetingDateViewController.swift
//  Alto
//
//  Created by Jaypreet on 26/10/21.
//

import UIKit
import Koyomi
import VACalendar

class MeetingDateViewController: UIViewController, KoyomiDelegate, VAMonthHeaderViewDelegate {
  
    
    
    @IBOutlet weak var viewDates: Koyomi!
    @IBOutlet weak var sgtMonth: UISegmentedControl!
    @IBOutlet weak var viewCalender: UIView!
    
    @IBOutlet weak var lblMonth: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBOutlet weak var monthHeaderView: VAMonthHeaderView! {
        didSet {
            let appereance = VAMonthHeaderViewAppearance(
                previousButtonImage: #imageLiteral(resourceName: "ic_next_grey"),
                nextButtonImage: #imageLiteral(resourceName: "ic_next_grey")
            )
            monthHeaderView.delegate = self
            monthHeaderView.appearance = appereance
        }
    }
    var calendarView: VACalendarView!

    @IBOutlet weak var weekDaysView: VAWeekDaysView! {
        didSet {
            let appereance = VAWeekDaysViewAppearance(symbolsType: .veryShort, calendar: defaultCalendar)
            weekDaysView.appearance = appereance
        }
    }
    var Language : String = ""
    var MeetingType : Int = 0
    var Tags : String = ""
    var SelectedDates : [String] = []

    let defaultCalendar: Calendar = {
        var calendar = Calendar.current
        calendar.firstWeekday = 1
        calendar.timeZone = TimeZone.autoupdatingCurrent
        
        return calendar
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let dateFormatter = DateFormatter()
//        dateFormatter.timeZone = TimeZone(identifier: timeZone)
        dateFormatter.locale = Locale(identifier: LocationCode)
        dateFormatter.dateFormat =  DateFormat.dd_MM_yyyy.get()
//        print(selectedDate)
        let today = dateFormatter.string(from: Date())
        SelectedDates.append(today)

        datePicker.minimumDate = Date().addingTimeInterval(60)
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
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyy"
        
        let startDate = Date()
        
        let currentDate = Date()
        var dateComponent = DateComponents()
         
        dateComponent.year = 5
        let endDate = Calendar.current.date(byAdding: dateComponent, to: startDate)
        
        let calendar = VACalendar(
            startDate: startDate,
            endDate: endDate,
            selectedDate : startDate,
            calendar: defaultCalendar
        )
        
        
     
        calendarView = VACalendarView(frame: .zero, calendar: calendar)
        calendarView.showDaysOut = false
        calendarView.startDate = startDate
        calendarView.selectionStyle = .multi
        calendarView.dayViewAppearanceDelegate = self
        calendarView.monthViewAppearanceDelegate = self
        calendarView.calendarDelegate = self
        calendarView.scrollDirection = .vertical
        //        calendarView.setSupplementaries([
//                    (Date().addingTimeInterval(-(60 * 60 * 70)), [VADaySupplementary.bottomDots([.red, .magenta])]),
//                    (Date().addingTimeInterval((60 * 60 * 110)), [VADaySupplementary.bottomDots([.red])]),
//                    (Date().addingTimeInterval((60 * 60 * 370)), [VADaySupplementary.bottomDots([.blue, .darkGray])]),
//                    (Date().addingTimeInterval((60 * 60 * 430)), [VADaySupplementary.bottomDots([.orange, .purple, .cyan])])
//                    ])
                viewCalender.addSubview(calendarView)
    }
    override func viewDidLayoutSubviews() {
          super.viewDidLayoutSubviews()
          
          if calendarView.frame == .zero {
              calendarView.frame = CGRect(
                  x: 0,
                  y: 0,
                  width: viewCalender.frame.width - 20,
                  height: viewCalender.frame.height - 40
              )
              calendarView.setup()
          }
      }
    @IBAction func Back(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }

    
    
    func didTapNextMonth() {
        
    }
    
    func didTapPreviousMonth() {
        
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
        if SelectedDates.count != 0{
            let vc = storyboard?.instantiateViewController(identifier: "MeetingTimeViewController") as! MeetingTimeViewController
            vc.Tags = Tags
            let formatter = DateFormatter()
            formatter.dateFormat = DateFormat.dd_MM_yyyy.get()
            vc.Dates =  SelectedDates.joined(separator: ",")
            if SelectedDates.contains(formatter.string(from: Date())){
                vc.Date_for = Date()
            }
            else{
                vc.Date_for = formatter.date(from: SelectedDates[0])
            }
            vc.Language = Language
            vc.MeetingType = MeetingType
            print(SelectedDates)
            navigationController?.pushViewController(vc, animated: true)
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
extension MeetingDateViewController{
    func koyomi(_ koyomi: Koyomi, didSelect date: Date?, forItemAt indexPath: IndexPath) {
        let dateFormatter = DateFormatter()
//        dateFormatter.timeZone = TimeZone(identifier: timeZone)
        dateFormatter.locale = Locale(identifier: LocationCode)
        dateFormatter.dateFormat =  DateFormat.dd_MM_yyyy.get()
        let selectedDate = dateFormatter.string(from: date!)
//        print(selectedDate)
        let today = dateFormatter.string(from: Date())

        if SelectedDates.contains(selectedDate){
            SelectedDates.remove(at: SelectedDates.firstIndex(where: { ($0 == selectedDate)}) ?? 0)
        }
        else{
            SelectedDates.append(selectedDate)
        }
        
        
    }
    func koyomi(_ koyomi: Koyomi, shouldSelectDates date: Date?, to toDate: Date?, withPeriodLength length: Int) -> Bool {
        let dateFormatter = DateFormatter()
//        dateFormatter.timeZone = TimeZone(identifier: timeZone)
        dateFormatter.locale = Locale(identifier: LocationCode)
        dateFormatter.dateFormat =  DateFormat.dd_MM_yyyy.get()
        let selectedDate = dateFormatter.string(from: date!)
        let toDate = dateFormatter.string(from: toDate ?? Date())
        let today = dateFormatter.string(from: Date())

        print(selectedDate)
        print(toDate)
        
        
        if selectedDate == today{
            return true
        }
        if date! < Date(){
            return false
        }
        return true
    }
}
extension MeetingDateViewController: VACalendarViewDelegate {
    
    func selectedDate(_ date: Date) {
        print(date)
    }
    func selectedDates(_ dates: [Date]) {
        print(dates)
        SelectedDates.removeAll()
        let dateFormatter = DateFormatter()
//        dateFormatter.timeZone = TimeZone(identifier: timeZone)
        dateFormatter.locale = Locale(identifier: LocationCode)
        dateFormatter.dateFormat =  DateFormat.dd_MM_yyyy.get()
        for i in dates {
            let selectedDate = dateFormatter.string(from: i)
            SelectedDates.append(selectedDate)

        }

    }
    
}
extension MeetingDateViewController: VADayViewAppearanceDelegate {
    
    func textColor(for state: VADayState) -> UIColor {
        switch state {
        case .out:
            return UIColor(red: 214 / 255, green: 214 / 255, blue: 219 / 255, alpha: 1.0)
        case .selected:
            return .white
        case .unavailable:
            return .lightGray
        default:
            return .black
        }
    }
    
    func textBackgroundColor(for state: VADayState) -> UIColor {
        switch state {
        case .selected:
            return .red
        default:
            return .clear
        }
    }
    
    func shape() -> VADayShape {
        return .circle
    }
    
    func dotBottomVerticalOffset(for state: VADayState) -> CGFloat {
        switch state {
        case .selected:
            return 2
        default:
            return -7
        }
    }
    
    
}
extension MeetingDateViewController: VAMonthViewAppearanceDelegate {
    
    func leftInset() -> CGFloat {
        return 10.0
    }
    
    func rightInset() -> CGFloat {
        return 10.0
    }
    
    func verticalMonthTitleFont() -> UIFont {
        return UIFont.systemFont(ofSize: 20, weight: .semibold)
    }
    
    func verticalMonthTitleColor() -> UIColor {
        return #colorLiteral(red: 0, green: 0.3294117647, blue: 0.5764705882, alpha: 1)
    }
    
    func verticalCurrentMonthTitleColor() -> UIColor {
        return .red
    }
    
    func verticalMonthDateFormater() -> DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "LLLL/yyyy"
        return dateFormatter
    }
    
}

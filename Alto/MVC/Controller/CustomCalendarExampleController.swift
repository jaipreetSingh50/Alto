import UIKit
import CalendarKit

class CustomCalendarExampleController: DayViewController {
  
  var data = [["Breakfast at Tiffany's",
               "New York, 5th avenue"],
              
              ["Workout",
               "Tufteparken"],
              
              ["Meeting with Alex",
               "Home",
               "Oslo, Tjuvholmen"],
              
              ["Beach Volleyball",
               "Ipanema Beach",
               "Rio De Janeiro"],
              
              ["WWDC",
               "Moscone West Convention Center",
               "747 Howard St"],
              
              ["Google I/O",
               "Shoreline Amphitheatre",
               "One Amphitheatre Parkway"],
              
              ["✈️️ to Svalbard ❄️️❄️️❄️️❤️️",
               "Oslo Gardermoen"],
              
              ["💻📲 Developing CalendarKit",
               "🌍 Worldwide"],
              
              ["Software Development Lecture",
               "Mikpoli MB310",
               "Craig Federighi"],
              
  ]
  
    var ListType : Int = 1
    var CollectionMeeting = [M_Request_Data]()

  var generatedEvents = [EventDescriptor]()
  var alreadyGeneratedSet = Set<Date>()
  
  var colors = [UIColor.blue,
                UIColor.yellow,
                UIColor.green,
                UIColor.red]

  private lazy var rangeFormatter: DateIntervalFormatter = {
    let fmt = DateIntervalFormatter()
    fmt.dateStyle = .none
    fmt.timeStyle = .short

    return fmt
  }()

  override func loadView() {
    calendar.timeZone = NSTimeZone.local

    dayView = DayView(calendar: calendar)
    view = dayView
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    title = "Calendar"
    SetBackButton()
    navigationController?.navigationBar.isTranslucent = false
    dayView.autoScrollToFirstEvent = true
    if DataManager.CurrentUserRole == UserRole.Senior.get(){
        GetSenorMeetingList(type: ListType)

    }
    else{
        GetMeetingList(type: ListType)

    }
  }
    
    func SetBackButton()  {
        let btn1 = UIButton(type: .custom)
        btn1.setBackgroundImage(#imageLiteral(resourceName: "ic_next_black-1"), for: .normal)
        btn1.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        btn1.addTarget(self, action: #selector(self.back(_:)), for: .touchDown)
        let item1 = UIBarButtonItem(customView: btn1)
        self.navigationItem.setLeftBarButton(item1, animated: true)
    }
    @objc func back(_ sender : UIButton)  {
        dismiss()
    }
    func GetSenorMeetingList(type : Int)  {
        let dict = ["type" : type,
                    ]
        
        APIClients.POST_user_meetingSeniorListCal(parems: dict) { (result) in
            switch result {
            case .success(let response):
                print(response)
                self.CollectionMeeting = response.data
                self.reloadData()

            case .failure(let error):
                print(error)
            }
            
        } failure: { (error) in
            print(error)
        }
    }
    func GetMeetingList(type : Int)  {
        let dict = ["type" : type,
                    ]
        
        APIClients.POST_user_meetingCompanionListCal(parems: dict) { (result) in
            switch result {
            case .success(let response):
                print(response)
                self.CollectionMeeting = response.data
                self.reloadData()

            case .failure(let error):
                print(error)
            }
            
        } failure: { (error) in
            print(error)
        }
    }
  
  // MARK: EventDataSource
  
  override func eventsForDate(_ date: Date) -> [EventDescriptor] {
    if !alreadyGeneratedSet.contains(date) {
      alreadyGeneratedSet.insert(date)
      generatedEvents.append(contentsOf: generateEventsForDate(date))
    }
    return generatedEvents
  }
  
  private func generateEventsForDate(_ date: Date) -> [EventDescriptor] {
    let selectedDay = date.get(.day, calendar: Calendar.current)
    var events = [Event]()

    for i in CollectionMeeting{
        let dates = CommonFunctions().convertJSONToArray(arrayObject: i.request_date)
        for j in dates{
            let date1 = j["date"] as! String
            let start_time = j["start_time"] as! String
            let end_time = j["end_time"] as! String
            let selectedDay1 = date1.GetDateFromString(format: DateFormat.dd_MM_yyyy.get()).get(.day, calendar: Calendar.current)
            if selectedDay == selectedDay1{
                let event = Event()
                event.startDate = "\(date1) \(start_time)".GetDateFromString(format: "dd/MM/yyyy HH:mm")
                event.endDate = "\(date1) \(end_time)".GetDateFromString(format: "dd/MM/yyyy HH:mm")
               
                event.text = "\(i.address_data?.complete_address ?? ""), \(i.address_data?.address ?? "")\n\(i.address_data?.city ?? ""),\(i.address_data?.state ?? "")\n\(i.address_data?.country ?? ""), \(i.address_data?.zip_code ?? "")"
                event.color = colors[Int(arc4random_uniform(UInt32(colors.count)))]
                event.lineBreakMode = .byTruncatingTail
                event.userInfo = String(i.id)
                events.append(event)

            }

        }
    }
    
    
    


    print("Events for \(date)")
    return events
  }
  
  // MARK: DayViewDelegate
  
  private var createdEvent: EventDescriptor?
  
  override func dayViewDidSelectEventView(_ eventView: EventView) {
    guard let descriptor = eventView.descriptor as? Event else {
      return
    }
    print("Event has been selected: \(descriptor) \(String(describing: descriptor.userInfo))")
  }
  
  override func dayViewDidLongPressEventView(_ eventView: EventView) {
    guard let descriptor = eventView.descriptor as? Event else {
      return
    }
    endEventEditing()
    print("Event has been longPressed: \(descriptor) \(String(describing: descriptor.userInfo))")
    beginEditing(event: descriptor, animated: true)
    print(Date())
  }
  
  override func dayView(dayView: DayView, didTapTimelineAt date: Date) {
    endEventEditing()
    print("Did Tap at date: \(date)")
  }
  
  override func dayViewDidBeginDragging(dayView: DayView) {
    endEventEditing()
    print("DayView did begin dragging")
  }
  
  override func dayView(dayView: DayView, willMoveTo date: Date) {
    print("DayView = \(dayView) will move to: \(date)")
  }
  
  override func dayView(dayView: DayView, didMoveTo date: Date) {
    print("DayView = \(dayView) did move to: \(date)")
  }
  
  override func dayView(dayView: DayView, didLongPressTimelineAt date: Date) {
    print("Did long press timeline at date \(date)")
    // Cancel editing current event and start creating a new one
    endEventEditing()
    let event = generateEventNearDate(date)
    print("Creating a new event")
    create(event: event, animated: true)
    createdEvent = event
  }
  
  private func generateEventNearDate(_ date: Date) -> EventDescriptor {
    let duration = Int(arc4random_uniform(160) + 60)
    let startDate = Calendar.current.date(byAdding: .minute, value: -Int(CGFloat(duration) / 2), to: date)!
    let event = Event()
    event.startDate = startDate
    event.endDate = startDate.addingTimeInterval(3600)

//    event.dateInterval = DateInterval(start: startDate, duration: TimeInterval(duration * 60))
    
    var info = data[Int(arc4random_uniform(UInt32(data.count)))]

    info.append(rangeFormatter.string(from: event.startDate, to: event.endDate))
    event.text = info.reduce("", {$0 + $1 + "\n"})
    event.color = colors[Int(arc4random_uniform(UInt32(colors.count)))]
    event.editedEvent = event

    return event
  }
  
  override func dayView(dayView: DayView, didUpdate event: EventDescriptor) {
    print("did finish editing \(event)")
    print("new startDate: \(event.startDate) new endDate: \(event.endDate)")
    
    if let _ = event.editedEvent {
      event.commitEditing()
    }
    
    if let createdEvent = createdEvent {
      createdEvent.editedEvent = nil
      generatedEvents.append(createdEvent)
      self.createdEvent = nil
      endEventEditing()
    }
    
    reloadData()
  }
}

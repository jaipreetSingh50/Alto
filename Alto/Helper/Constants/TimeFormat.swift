//
//  TimeFormat.swift
//  SOC
//
//  Created by Apple on 18/01/18.
//  Copyright © 2018 OREM TECH. All rights reserved.
//

import UIKit

var ServerTime : Date = Date()
var timeZone : String = NSTimeZone.local.identifier
var LocationCode : String = NSLocale.current.identifier

class TimeFormat: NSObject {
    

    func GetTimeZone() {
        timeZone = NSTimeZone.local.identifier
        LocationCode = NSLocale.current.identifier
        print(ServerTime)
    }
 
    func GetToday(format : String) -> String {
        let date = Date()
        let dateFormatter = DateFormatter()
//        dateFormatter.timeZone = TimeZone(identifier: timeZone)
        dateFormatter.locale = Locale(identifier: LocationCode)
        dateFormatter.dateFormat =  format
        return dateFormatter.string(from: date)
    }
    
 
    func GetDateFromTime(date : String) -> String {
        let unixTimestamp = Double(date)
        let date1 = Date(timeIntervalSince1970: unixTimestamp ?? 0.00)
        
        let dateFormatter = DateFormatter()
        //        dateFormatter.timeZone = TimeZone(identifier: timeZone)
        dateFormatter.locale = Locale(identifier: LocationCode)
        
        dateFormatter.dateFormat =  "dd MMM, h:mm a"
        return dateFormatter.string(from: date1)
        
    }
    
    func GetDifferenceWithTime(date : String) -> String {
        let unixTimestamp = Double(date)
        let date1 = Date(timeIntervalSince1970: unixTimestamp ?? 0.00)

        let dateFormatter = DateFormatter()
//        dateFormatter.timeZone = TimeZone(identifier: timeZone)
        dateFormatter.locale = Locale(identifier: LocationCode)
        
        let diffInDays = Calendar.current.dateComponents([.second], from: date1, to: Date()).second
        if diffInDays != nil{

            if (diffInDays!) < 60{
                return "\(diffInDays ?? 0) seconds ago"
            }
            if diffInDays! > 60 && diffInDays! < 3600{
                return "\((diffInDays ?? 0)/60) minutes ago"
            }
            if diffInDays! > 3600 && diffInDays! < 3600 * 24{
                return "\((diffInDays ?? 0)/3600) hours ago"
            }
            if  diffInDays! > 3600 * 24{
                return "\((diffInDays ?? 0)/(3600 * 24)) days ago"
            }
        }
             return "Just Now"
    }
 
    func ConvertDateFormat(date : String) -> String {
       
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: LocationCode)
        
        
        dateFormatter.dateFormat =  "yyyy-MM-dd HH:mm:ss"
        if dateFormatter.date(from: date) != nil{
            let dateTemp = dateFormatter.date(from: date)
            dateFormatter.dateFormat =  "MMM, HH:mm"
            
            return dateFormatter.string(from: dateTemp!)
        }
        
        
        return ""
        
    }
    func GetOrderDate(date : String) -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: LocationCode)
        
        
        dateFormatter.dateFormat =  "yyyy-MM-dd HH:mm:ss"
        if dateFormatter.date(from: date) != nil{
            let dateTemp = dateFormatter.date(from: date)
            dateFormatter.dateFormat =  "E MMM, d,yyyy"
            return dateFormatter.string(from: dateTemp!)
        }
        
        return ""
        
    }
    func GetOrderTime(date : String) -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: LocationCode)
        
        
        dateFormatter.dateFormat =  "yyyy-MM-dd HH:mm:ss"
        if dateFormatter.date(from: date) != nil{
            let dateTemp = dateFormatter.date(from: date)
            dateFormatter.dateFormat =  "hh:mm a"
            
            return dateFormatter.string(from: dateTemp!)
        }
        
        
        return ""
        
    }
    func ConvertTimeFormat(date : String) -> String {
        if date == "00:00:00"
        {
            return ""
        }
        let today = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: LocationCode)
        dateFormatter.dateFormat =  "dd MMM yyyy"
        
        let dateToday = dateFormatter.string(from: today)
        
        let compDate = "\(dateToday) \(date)"
        dateFormatter.dateFormat =  "dd MMM yyyy HH:mm:ss"
        if dateFormatter.date(from: compDate) != nil{
            let dateTemp = dateFormatter.date(from: compDate)
            dateFormatter.dateFormat =  "HH:mm"
            
            return dateFormatter.string(from: dateTemp!)
        }
        
        
        return ""
        
    }
    func GetCurrentTime() -> String {
        
        let today = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat =  "yyyy-MM-dd HH:mm:ss"
       
            
        return dateFormatter.string(from: today)
        
        
        
        
    }
    func GetDateToUpload(date : String) -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat =  "dd/MM/yyyy hh:mm a"
        
        if dateFormatter.date(from: date) != nil{
            let dateTemp = dateFormatter.date(from: date)
            dateFormatter.dateFormat =  "yyyy-MM-dd HH:mm:ss"
            
            return dateFormatter.string(from: dateTemp!)
        }
        return ""
    }
    
    
    func GetCurrent(date1 : String , date2 : String) -> Bool {
       
        let today = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: LocationCode)
        dateFormatter.dateFormat =  "dd MMM yyyy"
        
        let dateToday = dateFormatter.string(from: today)
        var dateStart = Date()
        var dateEnd = Date()

        let Start = "\(dateToday) \(date1)"
        let End = "\(dateToday) \(date2)"

        dateFormatter.dateFormat =  "dd MMM yyyy HH:mm:ss"
        if dateFormatter.date(from: Start) != nil{
            dateStart = dateFormatter.date(from: Start)!
        }
        else{
            return false
        }
        if dateFormatter.date(from: End) != nil{
            dateEnd = dateFormatter.date(from: End)!
        }
        else{
            return false
        }
        
        return today.isBetweeen(date: dateStart, andDate: dateEnd)
        
    }

}
extension Date {
    func isBetweeen(date date1: Date, andDate date2: Date) -> Bool {
        return date1.compare(self) == self.compare(date2)
    }
}
extension Int{
    func secondsToHoursMinutesSeconds() -> (Int, Int, Int, String) {
        
        let interval = self

        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.unitsStyle = .abbreviated

        let formattedString = formatter.string(from: TimeInterval(interval))!
        
        return (self / 3600, (self % 3600) / 60, (self % 3600) % 60 , formattedString)
    }
}
extension String{
  
    func  GetDateFromString(format : String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: LocationCode)
        dateFormatter.dateFormat =  format
        if dateFormatter.date(from: self) != nil{
            return dateFormatter.date(from: self) ?? Date()
        }
        return Date()
    }
    
    
    func  getTime(format : String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: LocationCode)
        
        
        dateFormatter.dateFormat =  "dd/MM/yyyy HH:mm"
        if dateFormatter.date(from: self) != nil{
            let dateTemp = dateFormatter.date(from: self)
            dateFormatter.dateFormat = format
            
            return dateFormatter.string(from: dateTemp!)
        }
        
        
        return ""
    }
    func  getTimeFromTime(currentFormat : String , requiredFormat : String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: LocationCode)
        
        
        dateFormatter.dateFormat =  currentFormat
        if dateFormatter.date(from: self) != nil{
            let dateTemp = dateFormatter.date(from: self)
            dateFormatter.dateFormat = requiredFormat
            
            return dateFormatter.string(from: dateTemp!)
        }
        
        
        return ""
    }
    func  getTimeStamp(format : String) -> String {
        
        var unixTimestamp = Double(self)
        if self.count == 13{
            unixTimestamp = unixTimestamp!/1000
        }
        let date1 = Date(timeIntervalSince1970: unixTimestamp ?? 0.00)
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: LocationCode)
        dateFormatter.dateFormat =  format
        return dateFormatter.string(from: date1)
        
    }
    func  getAge() -> String {
        let dateFormatter = DateFormatter()
        print(self)
        dateFormatter.dateFormat =  "yyyy-MM-dd"
        let date = dateFormatter.date(from: self)
        if date == nil{
            return "-"
        }
        let diffInDays = Calendar.current.dateComponents([.day], from: Date(), to: date!).day
        print(diffInDays)

            if diffInDays != nil{
                return "\(diffInDays! + 1)"
            }
            return "-"
    }
    func  getTimeAgo(format : String = "yyyy-MM-dd HH:mm:ss") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: LocationCode)
        dateFormatter.dateFormat = format
        let date = dateFormatter.date(from: self)
        let diffInDays = Calendar.current.dateComponents([.second], from: date!, to: Date()).second
            if diffInDays != nil{
                if (diffInDays!) < 60{
                    return "\(diffInDays ?? 0) seconds ago"
                }
                if diffInDays! > 60 && diffInDays! < 3600{
                    return "\((diffInDays ?? 0)/60) minutes ago"
                }
                if diffInDays! > 3600 && diffInDays! < 3600 * 24{
                    return "\((diffInDays ?? 0)/3600) hours ago"
                }
                if  diffInDays! > 3600 * 24{
                    return "\((diffInDays ?? 0)/(3600 * 24)) days ago"
                }
            }
                 return "Just Now"
        }
    func  getTimeLeft(format : String = "dd/MM/yyyy HH:mm", from : Date = Date()) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: LocationCode)
        dateFormatter.dateFormat = format
        if dateFormatter.date(from: self) == nil{
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"

        }
        
        let date = dateFormatter.date(from: self)
        let diffInDays = Calendar.current.dateComponents([.second], from: from, to: date!).second
            if diffInDays != nil{
                if (diffInDays!) < 60{
                    return "\(diffInDays ?? 0) seconds left"
                }
                if diffInDays! > 60 && diffInDays! < 3600{
                    return "\((diffInDays ?? 0)/60) minutes left"
                }
                if diffInDays! > 3600 && diffInDays! < 3600 * 24{
                    return "\((diffInDays ?? 0)/3600) hours left"
                }
                if  diffInDays! > 3600 * 24{
                    return "\((diffInDays ?? 0)/(3600 * 24)) days left"
                }
            }
                 return "Just Now"
        }
    func  getTimeLeftFrom(format : String = "dd/MM/yyyy HH:mm", from : Date = Date()) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: LocationCode)
        dateFormatter.dateFormat = format
        if dateFormatter.date(from: self) == nil{
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"

        }
        
        let date = dateFormatter.date(from: self)?.addingTimeInterval(60 * 60 * 24)
        let diffInDays = Calendar.current.dateComponents([.second], from: from, to: date!).second
            if diffInDays != nil{
                if (diffInDays!) < 60{
                    return "\(diffInDays ?? 0) seconds left"
                }
                if diffInDays! > 60 && diffInDays! < 3600{
                    return "\((diffInDays ?? 0)/60) minutes left"
                }
                if diffInDays! > 3600 && diffInDays! < 3600 * 24{
                    return "\((diffInDays ?? 0)/3600) hours left"
                }
                if  diffInDays! > 3600 * 24{
                    return "\((diffInDays ?? 0)/(3600 * 24)) days left"
                }
            }
                 return "Ended"
        }

    func  getTimeInterval(from StartTime : String, format : String = "dd/MM/yyyy HH:mm") -> Int {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: LocationCode)
        dateFormatter.dateFormat = format
        if dateFormatter.date(from: self) == nil{
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        }
        
        let edate = dateFormatter.date(from: self)
        let sdate = dateFormatter.date(from: StartTime)

        let diffInDays = Calendar.current.dateComponents([.hour], from: sdate!, to: edate!).hour
            if diffInDays != nil{
                return diffInDays ?? 0
            
            }
                 return 0
        }

    func  getTimeAgoTimeStamp() -> String {
        
        var unixTimestamp = Double(self)
        if self.count == 13{
            unixTimestamp = unixTimestamp!/1000
        }
        let date1 = Date(timeIntervalSince1970: unixTimestamp ?? 0.00)
        
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: LocationCode)
        dateFormatter.dateFormat =  "yyyy-MM-dd HH:mm:ss"
        let diffInDays = Calendar.current.dateComponents([.second], from: date1, to: Date()).second
            if diffInDays != nil{
                if (diffInDays!) < 60{
                    return "\(diffInDays ?? 0) seconds ago"
                }
                if diffInDays! > 60 && diffInDays! < 3600{
                    return "\((diffInDays ?? 0)/60) minutes ago"
                }
                if diffInDays! > 3600 && diffInDays! < 3600 * 24{
                    return "\((diffInDays ?? 0)/3600) hours ago"
                }
                if  diffInDays! > 3600 * 24{
                    return "\((diffInDays ?? 0)/(3600 * 24)) days ago"
                }
            }
                 return "Just Now"
        }

}
extension Date {
    func get(_ components: Calendar.Component..., calendar: Calendar = Calendar.current) -> DateComponents {
        return calendar.dateComponents(Set(components), from: self)
    }

    func get(_ component: Calendar.Component, calendar: Calendar = Calendar.current) -> Int {
        return calendar.component(component, from: self)
    }
}

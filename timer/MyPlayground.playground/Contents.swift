import UIKit
import Foundation



func formatTimer(s:TimeInterval) -> String {
    let formatter = DateComponentsFormatter()
    let MINUTE = 60
    let SECOND = 0
    let HOUR = MINUTE * 60
    let DAY = HOUR * 24
    let WEEK = DAY * 7
    let MONTH = DAY * 30
    
    switch Int(s) {
    case SECOND...HOUR:
        print("minutes")
        formatter.allowedUnits = [.minute, .second]
        formatter.unitsStyle = .positional
    case HOUR...DAY:
        print("hours")
        formatter.allowedUnits = [.hour, .minute]
        formatter.unitsStyle = .abbreviated
    case DAY...WEEK:
        print("days")
        formatter.allowedUnits = [.day, .hour]
        formatter.unitsStyle = .abbreviated
    case WEEK...MONTH:
        print("weeks")
        formatter.allowedUnits = [.day, .hour]
        formatter.unitsStyle = .abbreviated
    case MONTH...:
        print("months")
        formatter.allowedUnits = [.month, .day]
        formatter.unitsStyle = .abbreviated
    default:
        print("default")
    }
    let formattedString = formatter.string(from: TimeInterval(s))!
    return formattedString
}

formatTimer(s: 30000)
formatTimer(s: 10)
formatTimer(s: 69)
formatTimer(s: 6000000)

let s = 25


switch s {
case ...10:
    ">10"
case ...20:
    ">20"
case ...30:
    ">30"
default:
    "def"
}


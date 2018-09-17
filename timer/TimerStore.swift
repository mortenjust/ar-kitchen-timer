//
//  TimerStore.swift
//  timer
//
//  Created by Morten Just Petersen on 7/12/18.
//  Copyright © 2018 Morten Just Petersen. All rights reserved.
//

import UIKit
import Foundation

var timerStore = TimerStore() // singleton

protocol UserTimerDelegate {
    func timerUpdated(seconds : TimeInterval, formatted : String)
}

class UserTimer {
    
    var nodeDelegate : UserTimerDelegate?
    var drawerDelegate : UserTimerDelegate?

    var seconds : TimeInterval = 0
    var timerImage : UIImage?
    
    var timer : Timer!
    
    init(secondsOffset : TimeInterval, image : UIImage) {
        seconds = secondsOffset
        timerImage = image
    }
    
    func start(){
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { (timerObj) in
            // time passed. Tell the delegates!
            self.seconds += 1
            self.requestUIUpdate()
        })
    }

    func requestUIUpdate(){
        let formatted = self.formatTimer(s: self.seconds)
        self.nodeDelegate?.timerUpdated(seconds: self.seconds,
                                        formatted: formatted)
        self.drawerDelegate?.timerUpdated(seconds: self.seconds, formatted: formatted)
    }
    
    func formattedSeconds() -> String {
        return formatTimer(s: seconds)
    }
    

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
            formatter.allowedUnits = [.minute, .second]
            formatter.unitsStyle = .positional
        case HOUR...DAY:
            formatter.allowedUnits = [.hour, .minute]
            formatter.unitsStyle = .abbreviated
        case DAY...WEEK:
            formatter.allowedUnits = [.day, .hour]
            formatter.unitsStyle = .abbreviated
        case WEEK...MONTH:
            formatter.allowedUnits = [.day, .hour]
            formatter.unitsStyle = .abbreviated
        case MONTH...:
            formatter.allowedUnits = [.month, .day]
            formatter.unitsStyle = .abbreviated
        default:
            print("default")
        }
        let formattedString = formatter.string(from: TimeInterval(s))!
        return formattedString
    }
    
    
}

class TimerStore: NSObject {
    var allTimers = [UserTimer]()
}

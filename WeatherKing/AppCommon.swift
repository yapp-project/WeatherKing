//
//  AppCommon.swift
//  WeatherKing
//
//  Created by USER on 24/05/2019.
//  Copyright © 2019 yapp. All rights reserved.
//

import Foundation

class AppCommon {
    static let baseURL: String = "http://15.164.86.162:3000/api"
    
    static var notificationDefaultAMTime: Double {
        let startOfDayTime: Double = Date().startOfDay.timeIntervalSince1970
        let defaultTime: Double = Date().getSpecificTimeOfDay(hour: 7).timeIntervalSince1970
        return defaultTime - startOfDayTime
    }
    static var notificationDefaultPMTime: Double {
        let startOfDayTime: Double = Date().startOfDay.timeIntervalSince1970
        let defaultTime: Double = Date().getSpecificTimeOfDay(hour: 20).timeIntervalSince1970
        return defaultTime - startOfDayTime
    }
    
    static var isDebugLogEnabled: Bool = false
    
    static func dprint(_ str: String) {
        if AppCommon.isDebugLogEnabled {
            NSLog("[RW][DEBUG] \(str)")
        }
    }
    
    static func eprint(_ str: String) {
        NSLog("[RW][Error] \(str)")
    }
}

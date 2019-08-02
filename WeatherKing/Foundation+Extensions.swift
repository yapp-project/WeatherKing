//
//  Foundation+Extensions.swift
//  WeatherKing
//
//  Created by sangdon.kim on 01/08/2019.
//  Copyright © 2019 yapp. All rights reserved.
//

import Foundation

extension Int {
    var tempFormat: String {
        return "\(self)°"
    }
}

extension Double {
    var tempFormat: String {
        return "\(self)°"
    }
    
    var simpleTimeTextFormat: String {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        formatter.dateFormat = "a h:mm"
        formatter.amSymbol = "오전"
        formatter.pmSymbol = "오후"
        
        let date: Date = Date(timeIntervalSince1970: self)
        return formatter.string(from: date)
    }
}

extension Date {
    var startOfDay: Date {
        return getSpecificTimeOfDay(hour: 0)
    }
    func getSpecificTimeOfDay(hour: Int, minute: Int = 0) -> Date {
        var calendar = Calendar(identifier: .gregorian)
        if let timeZone = TimeZone(secondsFromGMT: 0) {
            calendar.timeZone = timeZone
        }
        let year: Int = calendar.component(.year, from: Date())
        let month: Int = calendar.component(.month, from: Date())
        let day: Int = calendar.component(.day, from: Date())
        return DateComponents(calendar: calendar, year: year, month: month, day: day, hour: hour, minute: minute).date ?? Date()
    }
}


var indexPathKey: UInt8 = 0
extension NSObject {
    @objc func saveIndexPath(indexPath: IndexPath) {
        objc_setAssociatedObject(self, &indexPathKey, indexPath, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    
    func indexPath() -> IndexPath? {
        return objc_getAssociatedObject(self, &indexPathKey) as? IndexPath
    }
}

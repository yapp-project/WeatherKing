//
//  RWHomeWeekCard.swift
//  WeatherKing
//
//  Created by SangDon Kim on 27/04/2019.
//  Copyright © 2019 yapp. All rights reserved.
//

import UIKit

class RWHomeWeekInfo {
    var daysAfter: Int
    var amStatus: String = ""
    var pmStatus: String = ""
    var minTemp: Int = 0
    var maxTemp: Int = 0
    
    var image: UIImage? {
        switch pmStatus {
        case "구름많음":
            return #imageLiteral(resourceName: "week_cloud_cloudy")
        case "구름조금":
            return #imageLiteral(resourceName: "week_cloud_bitCloudy")
        case "맑음":
            return #imageLiteral(resourceName: "week_cloud_sunny")
        case "비":
            return #imageLiteral(resourceName: "week_cloud_rain")
        case "눈":
            return #imageLiteral(resourceName: "week_cloud_snow")
        case "천둥번개":
            return #imageLiteral(resourceName: "week_cloud_thunder")
        case "안개":
            return #imageLiteral(resourceName: "week_cloud_foggy")
        default:
            return #imageLiteral(resourceName: "week_cloud_sunny")
        }
    }
    
    init(daysAfter: Int) {
        self.daysAfter = daysAfter
    }
}

class RWHomeWeekCard: RWHomeCard {
    var mainColor: UIColor = .lightishBlue
    var weekInfos: [RWHomeWeekInfo] = []
}

public enum WeatherWeekType {
    case good
    case notBad
    case bad
    case worse
    case worst
    
    var title: String {
        switch self {
        case .good:
            return "대기질 좋음"
        case .notBad:
            return "대기질 보통"
        case .bad:
            return "대기질 나쁨"
        case .worse:
            return "대기질 매우나쁨"
        case .worst:
            return "대기질 최악"
        }
    }
    
    var dustDescription: String {
        switch self {
        case .good:
            return "미세먼지 좋음"
        case .notBad:
            return "미세먼지 좋음"
        case .bad:
            return "미세먼지 나쁨"
        case .worse:
            return "미세먼지 매우나쁨"
        case .worst:
            return "미세먼지 최악"
        }
    }
    
    var ultraDustDescription: String {
        switch self {
        case .good:
            return "초미세먼지 좋음"
        case .notBad:
            return "초미세먼지 보통"
        case .bad:
            return "초미세먼지 나쁨"
        case .worse:
            return "초미세먼지 매우나쁨"
        case .worst:
            return "초미세먼지 매우나쁨"
        }
    }
    
    var image: UIImage? {
        switch self {
        case .good:
            return UIImage(named: "dust_good")
        case .notBad:
            return UIImage(named: "dust_default")
        case .bad:
            return UIImage(named: "dust_bad")
        case .worse:
            return UIImage(named: "dust_worse")
        case .worst:
            return UIImage(named: "dust_worst")
        }
    }
    
    var color: UIColor {
        switch self {
        case .good:
            return .dodgerBlue
        case .notBad:
            return .boringGreen
        case .bad:
            return .mango
        case .worse:
            return .salmon
        case .worst:
            return .gunmetal
        }
    }
}

class WeatherWeekData {
    var type: String = ""
    var description: String = ""
    var degree: Double = 0
    var format: String = ""
}


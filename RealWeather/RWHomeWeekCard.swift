//
//  RWHomeWeekCard.swift
//  RealWeather
//
//  Created by SangDon Kim on 27/04/2019.
//  Copyright © 2019 yapp. All rights reserved.
//

import UIKit

class RWHomeWeekCard: RWHomeCard {
    var mainColor: UIColor {
        return type.color
    }
    
    // 컬러 여러가지
    //    let mainColor: UIColor = .lightishBlue
    var type: WeatherWeekType = .good
    var dustDatas: [WeatherDustData] = []
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


//
//  WeatherCard.swift
//  RealWeather
//
//  Created by SangDon Kim on 30/03/2019.
//  Copyright © 2019 yapp. All rights reserved.
//

import UIKit

// TODO: 디자인 & 설계 제대로 나오면 전부 재설계 필요

class WeatherCard {

}

public enum WeatherDustType {
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
            return "좋음"
        case .notBad:
            return "좋음"
        case .bad:
            return "나쁨"
        case .worse:
            return "매우나쁨"
        case .worst:
            return "최악"
        }
    }
    
    var ultraDustDescription: String {
        switch self {
        case .good:
            return "좋음"
        case .notBad:
            return "보통"
        case .bad:
            return "나쁨"
        case .worse:
            return "매우나쁨"
        case .worst:
            return "매우나쁨"
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

class WeatherDustCard: WeatherCard {
    // 컬러 여러가지
//    let mainColor: UIColor = .lightishBlue
    var type: WeatherDustType = .good
    var dustDatas: [WeatherDustData] = []
}

class WeatherDustData {
    var type: String = ""
    var description: String = ""
    var degree: Double = 0
    var format: String = ""
}

public enum WeatherTempType {
    case warm
    case cold
    case hot
    case `default`
    case windy
    
    var image: UIImage? {
        switch self {
        case .warm:
            return UIImage(named: "cloud_warm")
        case .cold:
            return UIImage(named: "cloud_cold")
        case .hot:
            return UIImage(named: "cloud_hot")
        case .default:
            return UIImage(named: "cloud_default")
        case .windy:
            return UIImage(named: "cloud_windy")
        }
    }
}

class WeatherTempCard: WeatherCard {
    let mainColor: UIColor = .lightishBlue
    var type: WeatherTempType = .warm
    var timeTempDatas: [WeatherTempTimeData] = []
    
    var description: String = ""
    var currentTemp: Int = 0
    var estimatedTemp: Int = 0
    var minTemp: Int = 0
    var maxTemp: Int = 0
}

class WeatherTempTimeData {
    var timeTitle: String = ""
    var weatherImage: UIImage?
    var temperature: Int = 0
}

public enum WeatherStatusType: String {
    case rain = "비"
    case snow = "눈"
    case thunder = "천둥"
    case foggy = "안개"
    case sunny = "맑음"
    case bitCloudy = "조금 흐림"
    case cloudy = "구름"
    
    var image: UIImage? {
        switch self {
        case .rain:
            return UIImage(named: "status_rain")
        case .snow:
            return UIImage(named: "status_snow")
        case .thunder:
            return UIImage(named: "status_thunder")
        case .foggy:
            return UIImage(named: "status_foggy")
        case .sunny:
            return UIImage(named: "status_sunny")
        case .bitCloudy:
            return UIImage(named: "status_bitCloudy")
        case .cloudy:
            return UIImage(named: "status_cloudy")
        }
    }
}

class WeatherStatusCard: WeatherCard {
    let mainColor: UIColor = .aquaMarine
    var type: WeatherStatusType = .sunny
    var statusDatas: [WeatherStatusData] = []
    
    var title: String = ""
    var description: String = ""
}

class WeatherStatusData {
    var type: String = ""
    var description: String = ""
    var degree: Double = 0
    var format: String = ""
}

class WeatherCompareCard: WeatherCard {
    let mainColor: UIColor = .aquaMarine
}

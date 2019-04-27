//
//  WeatherStatusCard.swift
//  RealWeather
//
//  Created by SangDon Kim on 27/04/2019.
//  Copyright © 2019 yapp. All rights reserved.
//

import Foundation
import UIKit

class WeatherStatusCard: WeatherCard {
    let mainColor: UIColor = .aquaMarine
    var type: WeatherStatusType = .sunny
    var statusDatas: [WeatherStatusData] = []
    
    var title: String = ""
    var description: String = ""
    var estimatedDegree: String = ""
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

class WeatherStatusData {
    var type: String = ""
    var description: String = ""
    var degree: Double = 0
    var format: String = ""
}

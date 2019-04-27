//
//  WeatherTempCard.swift
//  RealWeather
//
//  Created by SangDon Kim on 27/04/2019.
//  Copyright © 2019 yapp. All rights reserved.
//

import Foundation
import UIKit

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

class WeatherTempTimeData {
    var timeTitle: String = ""
    var isCurrent: Bool = true
    var weatherImage: UIImage?
    var temperature: Int = 0
}

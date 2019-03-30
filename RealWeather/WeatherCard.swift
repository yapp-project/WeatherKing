//
//  WeatherCard.swift
//  RealWeather
//
//  Created by SangDon Kim on 30/03/2019.
//  Copyright © 2019 yapp. All rights reserved.
//

import UIKit

class WeatherCard {
    var mainColor: UIColor = .lightishBlue
    var image: UIImage?
    var description: String = ""
    var currentTemp: Int = 0
    var estimatedTemp: Int = 0
    var minTemp: Int = 0
    var maxTemp: Int = 0
}

class WeatherDustCard: WeatherCard {
    var dustDatas: [WeatherDustData] = []
}

class WeatherDustData {
    var type: String = ""
    var description: String = ""
    var degree: Double = 0
    var format: String = ""
}


class WeatherTempCard: WeatherCard {
    var timeTempDatas: [WeatherTempTimeData] = []
}

class WeatherTempTimeData {
    var timeTitle: String = ""
    var weatherImage: UIImage?
    var temperature: Int = 0
}

class WeatherStatusCard: WeatherCard {
    var statusDatas: [WeatherStatusData] = []
}

class WeatherStatusData {
    var type: String = ""
    var description: String = ""
    var degree: Double = 0
    var format: String = ""
}

class WeatherCompareCard: WeatherCard {
    
}

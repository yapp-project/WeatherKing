//
//  RWHomeStatusCard.swift
//  WeatherKing
//
//  Created by SangDon Kim on 27/04/2019.
//  Copyright © 2019 yapp. All rights reserved.
//

import Foundation
import UIKit

class RWHomeStatusCard: RWHomeCard {
    // 밤일 경우 색상 어둡게 변경 -> 현재 시간 가져오는 유틸 제작 필요
    var mainColor: UIColor {
        return #colorLiteral(red: 0, green: 0.8658255339, blue: 0.650185287, alpha: 1)
    }
    
    // TODO: 타입 매칭 필요함.
    var type: RWHomeStatusType = .sunny
    var timeTempDatas: [RWHomeTempTimeData] = []
    
    // TODO: 서버측 작업 중. 내려오면 파싱
    var snowfall: Int = 0
    var precipitation: Int = 0
    
    var humidity: Int = 0
    var windVelocity: Double = 0
    var rainProbability: Int = 0
}

public enum RWHomeStatusType: String {
    case rain = "비"
    case snow = "눈"
    case thunder = "천둥"
    case foggy = "안개"
    case sunny = "맑음"
    case bitCloudy = "조금 흐림"
    case cloudy = "구름"
    
    var description: String {
        switch self {
        case .sunny:
            return "해가 전세낸 날"
        case .bitCloudy:
            return "구름 약간 맑은 하늘"
        case .cloudy:
            return "흐리멍텅 구름가득"
        case .rain:
            return "빗방울이 또륵또륵"
        case .snow:
            return "눈사람 만들기 좋은 날"
        case .foggy:
            return "안개"
        case .thunder:
            return "번개"
        }
    }
    
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
        // return UIImage(named: "status_sunny_night")
        case .bitCloudy:
            return UIImage(named: "status_bitCloudy")
        // return UIImage(named: "status_bitCloudy_night")
        case .cloudy:
            return UIImage(named: "status_cloudy")
        }
    }
}

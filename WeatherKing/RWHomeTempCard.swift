//
//  RWHomeTempCard.swift
//  WeatherKing
//
//  Created by SangDon Kim on 27/04/2019.
//  Copyright © 2019 yapp. All rights reserved.
//

// 추가가 필요한 로직 -> 현재 시간과 tempTime 비교가 가능해야 함
// 주간 -> 받아온 정보를 요일 정보로 컨버팅할 수 있어야 한다.

import Foundation
import UIKit

enum RWHomeDateType {
    case today
    case tomorrow
    
    var description: String {
        switch self {
        case .today:
            return "오늘은"
        case .tomorrow:
            return "내일은"
        }
    
    }
}

class RWHomeTempCard: RWHomeCard {
    let mainColor: UIColor = .lightishBlue
    var dateType: RWHomeDateType = .today
    var type: RWHomeTempDegree = .upTo5c
    var timeTempDatas: [RWHomeTempTimeData] = []
    var humidity: Int = 0
    var currentTemp: Double = 0.0
    var relativeTemp: Int = 0 // TODO: 2차 진행
    var minTemp: Int {
        return timeTempDatas.sorted { $0.minTemp > $1.minTemp }.first?.minTemp ?? 0
    }
    var maxTemp: Int {
        return timeTempDatas.sorted { $0.temperature > $1.temperature }.first?.temperature ?? 0
    }
}

public enum RWHomeTempDegree {
    case upTo5c
    case upTo9c
    case upTo11c
    case upTo16c
    case upTo19c
    case upTo23c
    case upTo27c
    case over27c
    
    init?(celsius: Double) {
        switch celsius {
        case ..<5:
            self = .upTo5c
        case 5...9:
            self = .upTo9c
        case 10...11:
            self = .upTo11c
        case 12..<16:
            self = .upTo16c
        case 16..<19:
            self = .upTo19c
        case 19..<23:
            self = .upTo23c
        case 23..<27:
            self = .upTo27c
        case 27...:
            self = .over27c
        default:
            return nil
        }
    }
    
    var title: String {
        switch self {
        case .upTo5c:
            return "흐늘흐늘 쌀쌀해"
        case .upTo9c:
            return "환절기 감기조심!"
        case .upTo11c:
            return "서늘서늘 하늘하늘"
        case .upTo16c:
            return "가죽자켓 봉인해제"
        case .upTo19c:
            return "외출하기 좋은날" // TODO: 습도에 따른 분기 필요. 2차 스펙
        case .upTo23c:
            return "기분좋게 따뜻한 날"
        case .upTo27c:
            return "슬슬 오는 더위"
        case .over27c:
            return "슬슬 오는 더위"
        }
    }
    
    var description: String {
        switch self {
        case .upTo5c:
            return "아직 추운 바깥세상"
        case .upTo9c:
            return "옷장을 열어볼까?"
        case .upTo11c:
            return "추위가 물러가는 중"
        case .upTo16c:
            return "시원한데 따뜻해" // TODO: 습도에 따른 분기 필요. 2차 스펙
        case .upTo19c:
            return "선선한 하루" // TODO: 습도에 따른 분기 필요. 2차 스펙
        case .upTo23c:
            return "여름을 준비할 때"
        case .upTo27c:
            return "햇빛이 또 성장 중"
        case .over27c:
            return "햇빛이 또 성장 중"
        }
    }
    
    var clotheDescription: String {
        switch self {
        case .upTo5c:
            return "패딩・목도리・장갑"
        case .upTo9c:
            return "코트・가죽자켓"
        case .upTo11c:
            return "트랜치코트・야상・레이어드"
        case .upTo16c:
            return "자켓・셔츠・가디건・야상"
        case .upTo19c:
            return "니트・가디건・후드・맨투맨・청바지"
        case .upTo23c:
            return "긴팔티・가디건・후드・면바지・슬랙스・스키니"
        case .upTo27c:
            return "반팔・얇은셔츠・반바지・면바지"
        case .over27c:
            return "나시・반바지・민소매・원피스"
        }
    }
    
    var image: UIImage? {
        switch self {
        case .upTo5c:
            return UIImage(named: "temp_cold")
        case .upTo9c, .upTo11c, .upTo16c:
            return UIImage(named: "temp_windy")
        case .upTo19c, .upTo23c:
            return UIImage(named: "temp_default")
        case .upTo27c:
            return UIImage(named: "temp_warm")
        case .over27c:
            return UIImage(named: "temp_hot")
        }
    }
}


enum RWHomeTempTime: String, CaseIterable {
    case am06 = "0600"
    case am09 = "0900"
    case am12 = "1200"
    case pm03 = "1500"
    case pm06 = "1800"
    case pm09 = "2100"
    
    var title: String {
        switch self {
        case .am06:
            return "새벽"
        case .am09:
            return "아침"
        case .am12:
            return "늦은 오전"
        case .pm03:
            return "이른 오후"
        case .pm06:
            return "늦은 오후"
        case .pm09:
            return "저녁"
        }
    }
}

enum RWHomeWeatherType: Int {
    case none // 하늘 상태별 멘트
    case rain // 강수량별 멘트
    case rainAndSnow // 축축한 진눈개비
    case snow // 적설량별 멘트
}

enum RWHomeSkyDegree: Int {
    case sunny
    case bitCloudy
    case cloudy
    case bad
    
    var status: String {
        switch self {
        case .sunny:
            return "맑음"
        case .bitCloudy:
            return "구름 조금"
        case .cloudy:
            return "구름 많음"
        case .bad:
            return "흐리멍텅 구름가득"
        }
    }
    
    var title: String {
        switch self {
        case .sunny:
            return "해가 전세낸 날"
        case .bitCloudy:
            return "구름 약간 맑은 하늘"
        case .cloudy:
            return "뭉게뭉게 뭉게구름"
        case .bad:
            return "흐리멍텅 구름가득"
        }
    }
}

enum RWHomeRainDegree {
    case upToPoint1mm
    case upTo1mm
    case upTo5mm
    case upTo10mm
    case upTo20mm
    case upTo40mm
    case upTo70mm
    case over70mm
    
    init?(millimeter: Double) {
        switch millimeter {
        case ..<0.1:
            self = .upToPoint1mm
        case 0.1..<1:
            self = .upTo1mm
        case 1..<5:
            self = .upTo5mm
        case 5..<10:
            self = .upTo10mm
        case 10..<20:
            self = .upTo20mm
        case 20..<40:
            self = .upTo40mm
        case 40..<70:
            self = .upTo70mm
        case ...Double.greatestFiniteMagnitude:
            self = .over70mm
        default:
            return nil
        }
    }
    
    var title: String {
        switch self {
        case .upToPoint1mm:
            return "부슬부슬 부슬비"
        case .upTo1mm:
            return "스쳐 가는 얕은 비"
        case .upTo5mm:
            return "조근조근 내리는 비"
        case .upTo10mm:
            return "빗방울이 또륵또륵"
        case .upTo20mm:
            return "빗방울 주륵주륵"
        case .upTo40mm:
            return "강한 비가 떨어지는 중"
        case .upTo70mm:
            return "우산을 때리는 빗소리"
        case .over70mm:
            return "비가 물처럼 쏟아지는 중"
        }
    }
}

enum RWHomeSnowDegree {
    case upToPoint1cm
    case upTo1cm
    case upTo5cm
    case upTo20cm
    case over20cm
    
    init?(centimeter: Double) {
        switch centimeter {
        case ..<0.1:
            self = .upToPoint1cm
        case 0.1..<1:
            self = .upTo1cm
        case 1..<5:
            self = .upTo5cm
        case 5..<10:
            self = .upTo20cm
        case 10..<20:
            self = .over20cm
        default:
            return nil
        }
    }
    
    var title: String {
        switch self {
        case .upToPoint1cm:
            return "바슬바슬 바슬눈"
        case .upTo1cm:
            return "금방 녹을 얕은 눈"
        case .upTo5cm:
            return "소복소복 소복눈"
        case .upTo20cm:
            return "눈사람 만들기 좋은 날"
        case .over20cm:
            return "강한 비가 떨어지는 중"
        }
    }
}

public class RWHomeTempTimeData {
    var weatherImage: UIImage?
    var temperature: Int = 0
    
    // TODO: Date or timeInterval로 변경 -> 서버 요청 필요
    var date: String = ""
    var time: RWHomeTempTime = .am06
    var weather: RWHomeWeatherType = .none
    var skyDegree: RWHomeSkyDegree = .sunny
    var rainDegree: RWHomeRainDegree?
    var snowDegree: RWHomeSnowDegree?
    var rainfall: Int = 0
    var snowfall: Int = 0
    var tempMessages: [String] = []
    var skyMessage: String = ""
    var humidity: Int = 0
    var windVelocity: Double = 0
    var rainPop: Int = 0
    var minTemp: Int = 0
}

public extension Dictionary where Key: ExpressibleByStringLiteral, Value: Any {
    func parseHomeTempTimeData() -> RWHomeTempTimeData {
        let tempTimeData = RWHomeTempTimeData()
        tempTimeData.date = (self["fcstDate"] as? String)?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
            
        let timeStr: String = (self["fcstTime"] as? String)?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        if let time = RWHomeTempTime(rawValue: timeStr) {
            tempTimeData.time = time
        }
        
        if let weatherIndex = (self["pty"] as? Int), let weather = RWHomeWeatherType(rawValue: weatherIndex) {
            tempTimeData.weather = weather
        }
        if let skyIndex = (self["sky"] as? Int), let skyDegree = RWHomeSkyDegree(rawValue: skyIndex) {
            tempTimeData.skyDegree = skyDegree
        }
        if let rainMillimeter = (self["rainfallValue"] as? Double), let rainDegree = RWHomeRainDegree(millimeter: rainMillimeter) {
            tempTimeData.rainDegree = rainDegree
            tempTimeData.rainfall = Int(rainMillimeter)
        }
        if let snowCentimeter = (self["snowfallValue"] as? Double), let snowDegree = RWHomeSnowDegree(centimeter: snowCentimeter) {
            tempTimeData.snowDegree = snowDegree
            tempTimeData.snowfall = Int(snowCentimeter)
        }
        tempTimeData.tempMessages = self["temp_message"] as? [String] ?? []
        tempTimeData.skyMessage = (self["sky_message"] as? String) ?? ""
        tempTimeData.humidity = (self["humid"] as? Int) ?? 0
        tempTimeData.windVelocity = (self["wind"] as? Double) ?? 0.0
        tempTimeData.rainPop = (self["rainPop"] as? Int) ?? 0
        tempTimeData.temperature = (self["temp"] as? Int) ?? 0
        tempTimeData.minTemp = (self["lowestTemp"] as? Int) ?? 0
        
        return tempTimeData
    }
}

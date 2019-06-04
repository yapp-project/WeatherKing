//
//  RWHomeDustCard.swift
//  WeatherKing
//
//  Created by SangDon Kim on 27/04/2019.
//  Copyright © 2019 yapp. All rights reserved.
//

import UIKit

class RWHomeDustCard: RWHomeCard {
    let cellType: HomeCellType = .weatherDustCard
    var mainColor: UIColor {
        return type.color
    }
    
    var type: RWHomeDustType = .good
    var providedTime: String = ""
    var fineDustDegree: Int = 0
    var ultraDustDegree: Int = 0
    var o3Degree: Double = 0.0
    var no2Degree: Double = 0.0
    var coDegree: Double = 0.0
    var so2Degree: Double = 0.0
}

public enum RWHomeDustType {
    case good
    case notBad
    case bad
    case worse
    case worst
    
    init?(fineDust: Int, ultraDust: Int) {
        switch (fineDust, ultraDust) {
        case (0...30, 0...15):
            self = .good
        case (31...50, 16...25):
            self = .notBad
        case (51...100, 26...50):
            self = .bad
        case (101...150, 51...101):
            self = .worse
        case (151...Int.max, 102...Int.max):
            self = .good
        default:
            return nil
        }
    }
    
    var title: String {
        switch self {
        case .good:
            return "대기상태 좋음"
        case .notBad:
            return "대기상태 보통"
        case .bad:
            return "대기상태 나쁨"
        case .worse:
            return "대기상태 매우나쁨"
        case .worst:
            return "대기상태 최악"
        }
    }
    
    static func fineDustDescription(fineDust: Int) -> String {
        switch fineDust {
        case 0...30:
            return RWHomeDustType.good.dustDescription
        case 31...50:
            return RWHomeDustType.notBad.dustDescription
        case 51...100:
            return RWHomeDustType.bad.dustDescription
        case 101...150:
            return RWHomeDustType.worse.dustDescription
        case 151...:
            return RWHomeDustType.worst.dustDescription
        default:
            return ""
        }
    }
    
    static func ultraDustDescription(ultraDust: Int) -> String {
        switch ultraDust {
        case 0...15:
            return RWHomeDustType.good.dustDescription
        case 16...25:
            return RWHomeDustType.notBad.dustDescription
        case 26...50:
            return RWHomeDustType.bad.dustDescription
        case 51...101:
            return RWHomeDustType.worse.dustDescription
        case 102...:
            return RWHomeDustType.worst.dustDescription
        default:
            return ""
        }
    }
    
    private var dustDescription: String {
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
            return "최악"
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

class WeatherDustData {
    var type: String = ""
    var description: String = ""
    var degree: Double = 0
    var format: String = ""
}

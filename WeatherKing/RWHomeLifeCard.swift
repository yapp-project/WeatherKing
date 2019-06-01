//
//  RWHomeLifeCard.swift
//  WeatherKing
//
//  Created by SangDon Kim on 27/04/2019.
//  Copyright © 2019 yapp. All rights reserved.
//

import UIKit

class RWHomeLifeCard: RWHomeCard {
    var mainColor: UIColor {
        if let _ = coughDegree {
            return RWHomeCoughDegree.color
        } else if let _ = heatDegree {
            return RWHomeHeatDegree.color
        } else {
            return RWHomeUVRayDegree.color
        }
    }
    
    var image: UIImage? {
        if let coughDegree = coughDegree {
            return coughDegree.image
        } else if let heatDegree = heatDegree {
            return heatDegree.image
        } else {
            return uvRayDegree?.image
        }
    }
    
    var title: String {
        if let coughDegree = coughDegree {
            return coughDegree.description
        } else if let heatDegree = heatDegree {
            return heatDegree.title
        } else {
            return uvRayDegree?.description ?? RWHomeUVRayDegree.low.description
        }
    }
    
    var coughDegree: RWHomeCoughDegree?
    var uvRayDegree: RWHomeUVRayDegree?
    var heatDegree: RWHomeHeatDegree?
    var tempDegree: RWHomeTempDegree?
    var uvRayPoint: Int = 0
}

public enum RWHomeCoughDegree: Int {
    case low
    case normal
    case high
    case veryHigh
    
    static let color: UIColor = #colorLiteral(red: 0.5921568627, green: 0.4588235294, blue: 0.9803921569, alpha: 1)
    
    var description: String {
        switch self {
        case .low:
            return "감기 확률 낮아"
        case .normal:
            return "감기 확률 그냥 보통"
        case .high:
            return "감기 확률 높음! 과로하지 말자"
        case .veryHigh:
            return "감기 확률 매우 높음! 체온을 유지하자"
        }
    }
    
    var image: UIImage? {
        switch self {
        case .low:
            return UIImage(named: "cough_low")
        case .normal:
            return UIImage(named: "cough_normal")
        case .high:
            return UIImage(named: "cough_high")
        case .veryHigh:
            return UIImage(named: "cough_veryhigh")
        }
    }
}

public enum RWHomeUVRayDegree {
    case low
    case normal
    case high
    case veryHigh
    case extremelyHigh
    
    init?(degree: Int) {
        switch degree {
        case 0...2:
            self = .low
        case 3...5:
            self = .normal
        case 6...7:
            self = .high
        case 8...10:
            self = .veryHigh
        case 11...Int.max:
            self = .extremelyHigh
        default:
            return nil
        }
    }
    
    static let color: UIColor = #colorLiteral(red: 1, green: 0.662745098, blue: 0.3019607843, alpha: 1)
    
    var description: String {
        switch self {
        case .low:
            return "따뜻한 햇볕"
        case .normal:
            return "선크림을 바르자"
        case .high:
            return "태양빛이 위험해"
        case .veryHigh:
            return "불고기가 되는 날"
        case .extremelyHigh:
            return "불나방이 되는 날"
        }
    }
    
    var image: UIImage? {
        switch self {
        case .low, .normal:
            return UIImage(named: "uvray_normal")
        case .high:
            return UIImage(named: "uvray_high")
        case .veryHigh:
            return UIImage(named: "uvray_veryhigh")
        case .extremelyHigh:
            return UIImage(named: "uvray_extremelyhigh")
        }
    }
}

public enum RWHomeHeatDegree {
    case low
    case normal
    case high
    case veryHigh
    case extremelyHigh
    
    init?(degree: Int) {
        switch degree {
        case ..<32:
            self = .low
        case 32..<41:
            self = .normal
        case 41..<54:
            self = .high
        case 54..<65:
            self = .veryHigh
        case 66...:
            self = .extremelyHigh
        default:
            return nil
        }
    }
    
    static let color: UIColor = #colorLiteral(red: 1, green: 0.7568627451, blue: 0.09803921569, alpha: 1)

    var image: UIImage? {
        switch self {
        case .low:
            return UIImage(named: "heat_low")
        case .normal:
            return UIImage(named: "heat_normal")
        case .high:
            return UIImage(named: "heat_high")
        case .veryHigh, .extremelyHigh:
            return UIImage(named: "heat_veryhigh")
        }
    }
    
    var title: String {
        switch self {
        case .low:
            return "열기 낮음"
        case .normal:
            return "열기 보통"
        case .high:
            return "열기 높음"
        case .veryHigh:
            return "열기 심각"
        case .extremelyHigh:
            return "열기 위험"
        }
    }
    
    var description: String {
        switch self {
        case .low:
            return "무더위로 피곤한 날"
        case .normal:
            return "열병이 가까이에"
        case .high:
            return "열사병 대기 중"
        case .veryHigh:
            return "한낮에 외출금지"
        case .extremelyHigh:
            return "한낮에 외출금지"
        }
    }
    
    var subDescription: String {
        switch self {
        case .low:
            return "오늘 해는 열일 중"
        case .normal:
            return "움직이지 말자"
        case .high:
            return "밖은 지금 헬게이트"
        case .veryHigh:
            return "여기가 불지옥"
        case .extremelyHigh:
            return "여기가 불지옥"
        }
    }
}


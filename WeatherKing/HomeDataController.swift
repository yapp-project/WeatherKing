//
//  HomeDataController.swift
//  WeatherKing
//
//  Created by sdondon on 23/02/2019.
//  Copyright © 2019 yapp. All rights reserved.
//

import Foundation

struct HomeData {
    static var defaultComment: RWComment = {
        let comment = RWComment()
        comment.nickname = "날씨왕"
        comment.subDescription = "이 없다구? 지금 당장 날씨 톡톡 터치!"
        comment.content = "오늘 날씨 어때요?\n날씨 톡톡에 날씨톡을 남겨주세요!"
        return comment
    }()
    
    var bestComments: [RWComment]
    var homeCards: [HomeWeatherMenu: [RWHomeCard]]
}

class HomeDataController {
    private let requestor: RWApiRequest = RWApiRequest()
    
    func requestData(for location: RWLocation, completion: @escaping (HomeData?) -> Void) {
        let queries: [URLQueryItem] = [
            URLQueryItem(name: "lat", value: "\(location.latitude)"),
            URLQueryItem(name: "lng", value: "\(location.longitude)")
        ]
        
        requestor.cancel()
        requestor.method = .get
        requestor.baseURLPath = AppCommon.baseURL + "/main"
        requestor.fetch(with: queries) { [weak self] data, error in
            let completionInMainThread = { (completion: @escaping (HomeData?) -> Void, result: HomeData?) in
                DispatchQueue.main.async {
                    completion(result)
                }
            }
            
            guard let data = data, error == nil else {
                completionInMainThread(completion, nil)
                return
            }
            
            do {
                let homeData: HomeData? = try self?.parseHomeData(data)
                completionInMainThread(completion, homeData)
            } catch {
                completionInMainThread(completion, nil)
            }
        }
    }
}

extension HomeDataController {
    private func parseHomeData(_ data: Data?) throws -> HomeData? {
        guard let data = data, let jsons = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] else {
            return nil
        }
        
        var bestComments: [RWComment] = []
        if let commentArray = jsons["best_board"] as? [[String: Any]] {
            bestComments = commentArray.compactMap { $0.parseComment() }
        }
        
        var todayCards: [RWHomeCard] = []
        var tomorrowCards: [RWHomeCard] = []
        var weekCards: [RWHomeCard] = []
        
        let todayTempCard: RWHomeTempCard = RWHomeTempCard()
        todayTempCard.dateType = .today
        let tomorrowTempCard: RWHomeTempCard = RWHomeTempCard()
        tomorrowTempCard.dateType = .tomorrow
        
        let todayStatusCard: RWHomeStatusCard = RWHomeStatusCard()
        let tomorrowStatusCard: RWHomeStatusCard = RWHomeStatusCard()
        
        // 온도 카드 생성, 생활 카드에도 이용
        var todayTempDegree: RWHomeTempDegree?
        if let current = jsons["current"] as? [String: Any] {
            // 기상 카드에도 이용
            let celsius: Double = (current["temp"] as? Double) ?? 0.0
            todayTempDegree = RWHomeTempDegree(celsius: celsius)
            todayTempCard.type = todayTempDegree ?? .upTo5c
            todayTempCard.currentTemp = celsius
            todayTempCard.humidity = (current["humid"] as? Int) ?? 0
        }
        
        // 온도, 기상 카드 생성 (오늘, 내일)
        var todayTempTimeDatas: [RWHomeTempTimeData] = []
        if let today = jsons["today"] as? [String: Any] {
            RWHomeTempTime.allCases.forEach { time in
                if let timeData = (today[time.rawValue] as? [String: Any])?.parseHomeTempTimeData() {
                    todayTempTimeDatas.append(timeData)
                }
            }
            todayTempCard.timeTempDatas = todayTempTimeDatas
            todayStatusCard.timeTempDatas = todayTempTimeDatas
        }
        
        var tomorrowTempDegree: RWHomeTempDegree?
        var tomorrowTempTimeDatas: [RWHomeTempTimeData] = []
        if let tomorrow = jsons["tomorrow"] as? [String: Any] {
            RWHomeTempTime.allCases.forEach { time in
                if let timeData = (tomorrow[time.rawValue] as? [String: Any])?.parseHomeTempTimeData() {
                    tomorrowTempTimeDatas.append(timeData)
                }
            }
            
            // 내일 날씨는 정오를 기준으로 처리
            let tomorrowAm12TimeData = tomorrowTempTimeDatas.filter { $0.time == .am12 }.first
            let celsius: Double = Double(tomorrowAm12TimeData?.temperature ?? 0)
            tomorrowTempDegree = RWHomeTempDegree(celsius: celsius)
            tomorrowTempCard.type = tomorrowTempDegree ?? .upTo5c
            tomorrowTempCard.currentTemp = celsius
            tomorrowTempCard.humidity = tomorrowAm12TimeData?.humidity ?? 0
            tomorrowTempCard.timeTempDatas = tomorrowTempTimeDatas
            tomorrowStatusCard.timeTempDatas = tomorrowTempTimeDatas
        }
        todayCards.append(todayTempCard)
        todayCards.append(todayStatusCard)
        tomorrowCards.append(tomorrowTempCard)
        tomorrowCards.append(tomorrowStatusCard)
        
        // 미세 먼지 카드 생성 (오늘)
        if let fineDustData = jsons["fineDust"] as? [String: Any] {
            let dustCard = RWHomeDustCard()
            dustCard.fineDustDegree = Int(fineDustData["pm10Value"] as? String ?? "") ?? 0
            dustCard.ultraDustDegree = Int(fineDustData["pm25Value"] as? String ?? "") ?? 0
            dustCard.providedTime = fineDustData["dataTime"] as? String ?? ""
            
            dustCard.o3Degree = Double((fineDustData["o3Value"] as? String) ?? "") ?? 0.0
            dustCard.no2Degree = Double((fineDustData["no2Value"] as? String) ?? "") ?? 0.0
            dustCard.coDegree = Double((fineDustData["coValue"] as? String) ?? "") ?? 0.0
            dustCard.so2Degree = Double((fineDustData["so2Value"] as? String) ?? "") ?? 0.0
            
            if let dustType = RWHomeDustType(fineDust: dustCard.fineDustDegree,
                                             ultraDust: dustCard.ultraDustDegree) {
                dustCard.type = dustType
            }
            todayCards.append(dustCard)
        }
        
        let todayLifeCard: RWHomeLifeCard = RWHomeLifeCard()
        let tomorrowLifeCard: RWHomeLifeCard = RWHomeLifeCard()
        
        todayLifeCard.tempDegree = todayTempDegree
        tomorrowLifeCard.tempDegree = tomorrowTempDegree
        
        // 생활 카드 생성 (오늘, 내일)
        var todayHeatDegree: RWHomeHeatDegree?
        var tomorrowHeatDegree: RWHomeHeatDegree?
        if let heat = jsons["heat"] as? [String: Any] {
            if let todayHeatJson = heat["today_heat"] as? [String: Any] {
                let degree = (todayHeatJson["key"] as? Int) ?? 0
                todayHeatDegree = RWHomeHeatDegree(degree: degree)
            }
            if let tomorrowHeatJson = heat["tomorrow_heat"] as? [String: Any] {
                let degree = (tomorrowHeatJson["key"] as? Int) ?? 0
                tomorrowHeatDegree = RWHomeHeatDegree(degree: degree)
            }
        }
        
        var todayUVRayDegree: RWHomeUVRayDegree?
        var tomorrowUVRayDegree: RWHomeUVRayDegree?
        if let ultrav = jsons["ultrav"] as? [String: Any] {
            let todayUltravKey: Int = (ultrav["today_ultrav"] as? Int) ?? 0
            let tomorrowUltravKey: Int = (ultrav["tomorrow_ultrav"] as? Int) ?? 0
            todayUVRayDegree = RWHomeUVRayDegree(degree: todayUltravKey)
            tomorrowUVRayDegree = RWHomeUVRayDegree(degree: tomorrowUltravKey)
            todayLifeCard.uvRayPoint = todayUltravKey
            tomorrowLifeCard.uvRayPoint = tomorrowUltravKey
        }
        
        todayLifeCard.heatDegree = todayHeatDegree
        todayLifeCard.uvRayDegree = todayUVRayDegree
        tomorrowLifeCard.heatDegree = tomorrowHeatDegree
        tomorrowLifeCard.uvRayDegree = tomorrowUVRayDegree
        
        todayCards.append(todayLifeCard)
        tomorrowCards.append(tomorrowLifeCard)
        
        // 주간 카드
        let weekCard: RWHomeWeekCard = RWHomeWeekCard()
        for daysAfter in 3...7 {
            let weekInfo: RWHomeWeekInfo = RWHomeWeekInfo(daysAfter: daysAfter)
            
            if let weekSky = jsons["weekSky"] as? [String: Any] {
                weekInfo.amStatus = (weekSky["wf\(daysAfter)Am"] as? String)?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
                weekInfo.pmStatus = (weekSky["wf\(daysAfter)Am"] as? String)?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
            }
            if let weekTemp = jsons["weekTemp"] as? [String: Any] {
                weekInfo.minTemp = (weekTemp["taMin\(daysAfter)"] as? Int) ?? 0
                weekInfo.maxTemp = (weekTemp["taMax\(daysAfter)"] as? Int) ?? 0
            }
            weekCard.weekInfos.append(weekInfo)
        }
        weekCards.append(weekCard)
        
        var homeCards: [HomeWeatherMenu: [RWHomeCard]] = [:]
        homeCards.updateValue(todayCards, forKey: .today)
        homeCards.updateValue(tomorrowCards, forKey: .tomorrow)
        homeCards.updateValue(weekCards, forKey: .week)
        
        return HomeData(bestComments: bestComments, homeCards: homeCards)
    }
}

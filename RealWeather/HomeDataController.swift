//
//  HomeDataController.swift
//  RealWeather
//
//  Created by sdondon on 23/02/2019.
//  Copyright © 2019 yapp. All rights reserved.
//

import Foundation

struct HomeData {
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
        let tomorrowTempCard: RWHomeTempCard = RWHomeTempCard()
        
        let todayStatusCard: RWHomeStatusCard = RWHomeStatusCard()
        let tomorrowStatusCard: RWHomeStatusCard = RWHomeStatusCard()
        
        // 온도 카드 생성, 생활 카드에도 이용
        var tempDegree: RWHomeTempDegree?
        if let current = jsons["current"] as? [String: Any] {
            // 기상 카드에도 이용
            let celsius: Double = (current["temp"] as? Double) ?? 0.0
            //            let humidity: Int = (current["humidity"] as? Int) ?? 0
            tempDegree = RWHomeTempDegree(celsius: celsius)
            todayTempCard.type = tempDegree ?? .upTo5c
            todayTempCard.currentTemp = celsius
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
        }
        
        var tomorrowTempTimeDatas: [RWHomeTempTimeData] = []
        if let tomorrow = jsons["tomorrow"] as? [String: Any] {
            RWHomeTempTime.allCases.forEach { time in
                if let timeData = (tomorrow[time.rawValue] as? [String: Any])?.parseHomeTempTimeData() {
                    tomorrowTempTimeDatas.append(timeData)
                }
            }
            tomorrowTempCard.timeTempDatas = tomorrowTempTimeDatas
        }
        todayCards.append(todayTempCard)
        todayCards.append(todayStatusCard)
        tomorrowCards.append(tomorrowTempCard)
        tomorrowCards.append(tomorrowStatusCard)
        
        // 미세 먼지 카드 생성 (오늘)
        if let fineDustData = jsons["fineDust"] as? [String: Any] {
            let dustCard = RWHomeDustCard()
            dustCard.fineDustDegree = (fineDustData["pm10Value"] as? Int) ?? 0
            dustCard.ultraDustDegree = (fineDustData["pm25Value"] as? Int) ?? 0
            
            if let dustType = RWHomeDustType(fineDust: dustCard.fineDustDegree,
                                             ultraDust: dustCard.ultraDustDegree) {
                dustCard.type = dustType
            }
            todayCards.append(dustCard)
        }
        
        let todayLifeCard: RWHomeLifeCard = RWHomeLifeCard()
        let tomorrowLifeCard: RWHomeLifeCard = RWHomeLifeCard()
        
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
        
        if let weekSky = jsons["weekSky"] as? [String: Any] {
//            let todayUltrav: Int = (ultrav["today_ultrav"] as? Int) ?? 0
//            let tomorrowUltrav: Int = (ultrav["tomorrow_ultrav"] as? Int) ?? 0
            let sky3AM = (weekSky["wf3Am"] as? String)?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
            let sky3PM = (weekSky["wf3Pm"] as? String)?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
            let sky4AM = (weekSky["wf4Am"] as? String)?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
            let sky4PM = (weekSky["wf4Pm"] as? String)?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
            let sky5AM = (weekSky["wf5Am"] as? String)?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
            let sky5PM = (weekSky["wf5Pm"] as? String)?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
            let sky6AM = (weekSky["wf6Am"] as? String)?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
            let sky6PM = (weekSky["wf6Pm"] as? String)?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
            let sky7AM = (weekSky["wf7Am"] as? String)?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
            let sky7PM = (weekSky["wf7Pm"] as? String)?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
            let sky8PM = (weekSky["wf8"] as? String)?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
            let sky9PM = (weekSky["wf9"] as? String)?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
            let sky10PM = (weekSky["wf10"] as? String)?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        }
        
        // enum으로 바꿔서 가져오자.
        if let weekTemp = jsons["weekTemp"] as? [String: Any] {
            let weekTempMin3 = (weekTemp["taMin3"] as? String)?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
            let weekTempMax3 = (weekTemp["taMax3"] as? String)?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
            let weekTempMin4 = (weekTemp["taMin4"] as? String)?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
            let weekTempMax4 = (weekTemp["taMax4"] as? String)?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
            let weekTempMin5 = (weekTemp["taMin5"] as? String)?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
            let weekTempMax5 = (weekTemp["taMax5"] as? String)?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
            let weekTempMin6 = (weekTemp["taMin6"] as? String)?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
            let weekTempMax6 = (weekTemp["taMax6"] as? String)?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
            let weekTempMin7 = (weekTemp["taMin7"] as? String)?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
            let weekTempMax7 = (weekTemp["taMax7"] as? String)?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        }
        
        var homeCards: [HomeWeatherMenu: [RWHomeCard]] = [:]
        homeCards.updateValue(todayCards, forKey: .today)
        homeCards.updateValue(tomorrowCards, forKey: .tomorrow)
        homeCards.updateValue(weekCards, forKey: .week)
        
        return HomeData(bestComments: bestComments, homeCards: homeCards)
    }
}

extension HomeDataController {
    
}

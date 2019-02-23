//
//  HomeTopDataController.swift
//  RealWeather
//
//  Created by sdondon on 23/02/2019.
//  Copyright © 2019 yapp. All rights reserved.
//

import Foundation

class WeatherData {
  var dummyString: String = ""
}

class HomeTopDataController {
  private let requestor: RWApiRequest = RWApiRequest()
  
  func requestData(completion: @escaping (Weather?) -> Void) {
    let request = URLRequest(url: URL(string: "http://9a035e92.ngrok.io/weather")!)
    
    requestor.cancel()
    requestor.baseURLPath = "http://9a035e92.ngrok.io/weather"
    requestor.fetch(with: request) { [weak self] data, error in
      let completionInMainThread = { (completion: @escaping (Weather?) -> Void, result: Weather?) in
        DispatchQueue.main.async {
          completion(result)
        }
      }
      
      guard let data = data, error == nil else {
        completionInMainThread(completion, nil)
        return
      }
      
      do {
        let weather: Weather? = try self?.parseWeather(with: data)
        completionInMainThread(completion, weather)
      } catch {
        completionInMainThread(completion, nil)
      }
    }
  }
}

extension HomeTopDataController {
  private func parseWeather(with data: Data?) throws -> Weather? {
    guard let data = data, let jsons = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] else {
      return nil
    }
    let weather: Weather = Weather()
    weather.location = jsons["location"] as? String ?? ""
    weather.comment = jsons["comment"] as? String ?? ""
    weather.temperature = jsons["temperature"] as? String ?? ""
    let today = jsons["todayWeather"] as? [[String: Any]]
    if let today = today {
        for element in today {
            weather.todayWeather.append(TodayWeather(time:element["time"] as? String ?? "", temp: element["temp"] as? Int ?? 0))
        }
    }
    
    return weather
  }
}

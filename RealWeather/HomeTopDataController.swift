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
    
    func requestData(completion: @escaping (WeatherData?) -> Void) {
        let queryItems: [URLQueryItem] = [URLQueryItem(name: "postId", value: "1")]
        
        requestor.cancel()
        requestor.baseURLPath = "https://jsonplaceholder.typicode.com/comments"
        requestor.fetch(with: queryItems) { [weak self] data, error in
            let completionInMainThread = { (completion: @escaping (WeatherData?) -> Void, result: WeatherData?) in
                DispatchQueue.main.async {
                    completion(result)
                }
            }
            
            guard let data = data, error == nil else {
                completionInMainThread(completion, nil)
                return
            }
            
            do {
                let weather: WeatherData? = try self?.parseWeather(with: data)
                completionInMainThread(completion, weather)
            } catch {
                completionInMainThread(completion, nil)
            }
        }
    }
}

extension HomeTopDataController {
    private func parseWeather(with data: Data?) throws -> WeatherData? {
        guard let data = data, let jsons = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [[String: Any]] else {
            return nil
        }
        
        print(jsons)
        return WeatherData()
    }
}

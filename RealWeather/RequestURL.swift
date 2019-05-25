//
//  RequestURL.swift
//  RealWeather
//
//  Created by yoo on 2019. 5. 23..
//  Copyright © 2019년 yapp. All rights reserved.
//

import Foundation

class RequestURL {
    func RequestURL(url: String, type: HTTPMethod, body: Data? = nil) {
        let encoed = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let url = URL(string: encoed)
        var request = URLRequest(url: url!)
        
        request.httpMethod = type.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = body
        
        let session = URLSession.shared
        let task = session.dataTask(with: request) { (data, response, error) in
            guard error == nil else {
                print("error : \(error!.localizedDescription)")
                return
            }
            do {
                if let anyData = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as? [[String:String]] {
                    print("data : \(anyData)")
                    //retuen 값에 있는 address_name값,위도, 경도 저장 -> 검색해보기
                    for address in anyData {
                        if let address_name = address["address_name"] {
                            var array:[String] = []
                            print("name :\(address_name)")
                            array.append(address_name)
                            print("address : \(array)")
                            let defaults = UserDefaults.standard
                            defaults.set(array, forKey: "address_name")
                        }
                    }
                }
                
            } catch {
                print(error.localizedDescription)
            }
        }
        task.resume()
    }
}



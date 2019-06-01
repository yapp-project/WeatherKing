//
//  RWLoginDataController.swift
//  WeatherKing
//
//  Created by USER on 25/05/2019.
//  Copyright © 2019 yapp. All rights reserved.
//

import Foundation

class RWLoginDataController {
    private let requestor: RWApiRequest = RWApiRequest()
    
    func register(user: RWUser, completion: @escaping (Bool?) -> Void) {
        let queries: [URLQueryItem] = [
            URLQueryItem(name: "type", value: "\(user.loginMethod.rawValue)"),
            URLQueryItem(name: "nickname", value: user.nickname),
            URLQueryItem(name: "userid", value: user.userID),
            URLQueryItem(name: "lat", value: "\(user.location.latitude)"),
            URLQueryItem(name: "lng", value: "\(user.location.longitude)")
        ]
        
        requestor.cancel()
        requestor.method = .post
        requestor.baseURLPath = AppCommon.baseURL + "/main/register"
        requestor.fetch(with: queries) { data, error in
            let completionInMainThread = { (completion: @escaping (Bool?) -> Void, result: Bool?) in
                DispatchQueue.main.async {
                    completion(result)
                }
            }
            
            guard let data = data, error == nil else {
                completionInMainThread(completion, nil)
                return
            }
            
            do {
                let result: Bool? = try self.parseRegisterResult(data)
                completionInMainThread(completion, result)
            } catch {
                completionInMainThread(completion, nil)
            }
        }
    }
    
    func login(user: RWUser, completion: @escaping (RWUser?) -> Void) {
        let queries: [URLQueryItem] = [
            URLQueryItem(name: "type", value: "\(user.loginMethod.rawValue)"),
            URLQueryItem(name: "userid", value: user.userID)
        ]
        
        requestor.cancel()
        requestor.method = .post
        requestor.baseURLPath = AppCommon.baseURL + "/main/login"
        requestor.fetch(with: queries) { data, error in
            let completionInMainThread = { (completion: @escaping (RWUser?) -> Void, user: RWUser?) in
                DispatchQueue.main.async {
                    completion(user)
                }
            }
            
            guard let data = data, error == nil else {
                completionInMainThread(completion, nil)
                return
            }
            
            do {
                let user: RWUser? = try self.parseUserInfo(data)
                completionInMainThread(completion, user)
            } catch {
                completionInMainThread(completion, nil)
            }
        }
    }
}

extension RWLoginDataController {
    private func parseUserInfo(_ data: Data?) throws -> RWUser? {
        guard let data = data, let jsons = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] else {
            return nil
        }
        
        var region = RWRegion()
        if let regionData = jsons["region"] as? [String: Any] {
            region.cityName = (regionData["cityName"] as? String) ?? ""
            region.sidoName = (regionData["sidoName"] as? String) ?? ""
            region.townName = (regionData["townName"] as? String) ?? ""
            region.pos = (regionData["pos"] as? String) ?? ""
        }
        
        var user: RWUser?
        if let loginType = jsons["type"] as? String, let loginMethod = SignUpMethod(rawValue: Int(loginType) ?? 5) {
            let userID: String = (jsons["userid"] as? String) ?? ""
            user = RWUser(userID: userID, loginMethod: loginMethod)
            user?._id = (jsons["_id"] as? String) ?? ""
            user?.salt = (jsons["salt"] as? String) ?? ""
            user?.uniqueID = (jsons["uid"] as? String) ?? ""
            user?.nickname = (jsons["cityName"] as? String) ?? ""
            user?.location.latitude = (jsons["lat"] as? Double) ?? 0.0
            user?.location.longitude = (jsons["lng"] as? Double) ?? 0.0
            user?.region = region
            user?.__v = (jsons["__v"] as? Int) ?? 0
        }
        return user
    }
    
    private func parseRegisterResult(_ data: Data) throws -> Bool? {
        guard let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] else {
            return nil
        }
        
        return (json["status"] as? Bool) ?? false
    }
}

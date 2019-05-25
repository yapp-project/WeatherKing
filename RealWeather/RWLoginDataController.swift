//
//  RWLoginDataController.swift
//  RealWeather
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
            URLQueryItem(name: "uid", value: user.uniqueID),
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
    
    func login(user: RWUser, completion: @escaping (Bool?) -> Void) {
        let queries: [URLQueryItem] = [
            URLQueryItem(name: "type", value: "\(user.loginMethod.rawValue)"),
            URLQueryItem(name: "uid", value: user.uniqueID)
        ]
        
        requestor.cancel()
        requestor.method = .post
        requestor.baseURLPath = AppCommon.baseURL + "/main/login"
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
                let result: Bool? = try self.parseLoginResult(data)
                completionInMainThread(completion, result)
            } catch {
                completionInMainThread(completion, nil)
            }
        }
    }
}

extension RWLoginDataController {
    private func parseLoginResult(_ data: Data) throws -> Bool? {
        guard let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] else {
            return nil
        }
        
        return (json["status"] as? Bool) ?? false
    }
    
    private func parseRegisterResult(_ data: Data) throws -> Bool? {
        guard let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] else {
            return nil
        }
        
        return (json["status"] as? Bool) ?? false
    }
}

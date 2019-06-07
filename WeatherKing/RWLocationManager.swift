//
//  RWLocationManager.swift
//  WeatherKing
//
//  Created by SangDon Kim on 27/03/2019.
//  Copyright © 2019 yapp. All rights reserved.
//

import Foundation
import CoreLocation

public struct RWLocation {
    // 기본 위치 - 서울역
    var name: String = "용산구 동자동"
    var latitude: Double = 37.5533118
    var longitude: Double = 126.9689441
}

extension Notification.Name {
    static let CurrentLocationDidUpdated = Notification.Name("CurrentLocationDidUpdated") // 기기 위치 업데이트
    static let UserLocationDidUpdated = Notification.Name("UserLocationDidUpdated") // 서버상의 유저 위치 정보 업데이트
}

class RWLocationManager: NSObject {
    static let shared = RWLocationManager()
    private let notification: NotificationCenter = NotificationCenter.default
    private let coreLocationManager = CLLocationManager()
    private let dataController = RWLocationDataController()
    
    var currentLocation: RWLocation = RWLocation()
    
    override init() {
        super.init()
        coreLocationManager.delegate = self
        coreLocationManager.requestWhenInUseAuthorization()
        coreLocationManager.desiredAccuracy = kCLLocationAccuracyBest
        coreLocationManager.startUpdatingLocation()
    }
    
    func updateCurrentLocation() {
        coreLocationManager.startUpdatingLocation()
    }
    
    func search(for keyword: String, completion: @escaping ([RWLocation]?) -> Void) {
        dataController.requestLocations(for: keyword, completion: completion)
    }
    
    func updateUserLocation(_ location: RWLocation, completion: (() -> Void)? = nil) {
        guard let user = RWLoginManager.shared.user else {
            completion?()
            return
        }
        
        dataController.requestUserLocationChange(of: user, to: location) { [weak self] user in
            guard user != nil else {
                completion?()
                return
            }
            
            RWLoginManager.shared.user = user
            self?.notification.post(name: .UserLocationDidUpdated, object: nil)
            completion?()
        }
    }
}

extension RWLocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedWhenInUse:
            coreLocationManager.startUpdatingLocation()
        case .authorizedAlways, .denied, .notDetermined, .restricted:
            // [sdondon] MARK: 기본 위치 이용
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            currentLocation.latitude = location.coordinate.latitude
            currentLocation.longitude = location.coordinate.longitude
            notification.post(name: .CurrentLocationDidUpdated, object: nil)
            coreLocationManager.stopUpdatingLocation()
        }
    }
}

class RWLocationDataController {
    private let requestor: RWApiRequest = RWApiRequest()
    
    func requestLocations(for keyword: String, completion: @escaping ([RWLocation]?) -> Void) {
        let queries: [URLQueryItem] = [URLQueryItem(name: "keyword", value: keyword)]
        
        requestor.cancel()
        requestor.method = .get
        requestor.baseURLPath = AppCommon.baseURL + "/setting/location"
        requestor.fetch(with: queries) { data, error in
            let completionInMainThread = { (completion: @escaping ([RWLocation]?) -> Void, result: [RWLocation]?) in
                DispatchQueue.main.async {
                    completion(result)
                }
            }
            
            guard let data = data, error == nil else {
                completionInMainThread(completion, nil)
                return
            }
            
            do {
                let locationDatas: [RWLocation]? = try self.parseLocations(data)
                completionInMainThread(completion, locationDatas)
            } catch {
                completionInMainThread(completion, nil)
            }
        }
    }
    
    func requestUserLocationChange(of user: RWUser?, to location: RWLocation, completion: @escaping (RWUser?) -> Void) {
        guard let user = user else {
            completion(nil)
            return
        }
        
        let json: [String: Any] = [
            "type": user.loginMethod.rawValue,
            "uid" : user.uniqueID,
            "lat" : location.latitude,
            "lng" : location.longitude
        ]
        
        requestor.cancel()
        requestor.method = .put
        requestor.baseURLPath = AppCommon.baseURL + "/setting/location"
        requestor.fetch(with: json) { data, error in
            let completionInMainThread = { (completion: @escaping (RWUser?) -> Void, result: RWUser?) in
                DispatchQueue.main.async {
                    completion(result)
                }
            }
            
            guard let data = data, error == nil else {
                completionInMainThread(completion, nil)
                return
            }
            
            do {
                let userData: RWUser? = try self.parseUserInfo(data)
                completionInMainThread(completion, userData)
            } catch {
                completionInMainThread(completion, nil)
            }
        }
    }
}

extension RWLocationDataController {
    private func parseUserInfo(_ data: Data?) throws -> RWUser? {
        guard let data = data, let jsons = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] else {
            return nil
        }
        
        let region = RWRegion()
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
    
    private func parseLocations(_ data: Data?) throws -> [RWLocation]? {
        guard let data = data, let jsons = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [[String: Any]] else {
            return nil
        }
        return jsons.compactMap { $0.parseLocation() }
    }
}

public extension Dictionary where Key: ExpressibleByStringLiteral, Value: Any {
    func parseLocation() -> RWLocation {
        var location: RWLocation = RWLocation()
        
        location.name = (self["address_name"] as? String)?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        if let latitudeStr = (self["y"] as? String)?.trimmingCharacters(in: .whitespacesAndNewlines) {
            location.latitude = Double(latitudeStr) ?? 0.0
        }
        if let longitudeStr = (self["x"] as? String)?.trimmingCharacters(in: .whitespacesAndNewlines) {
            location.latitude = Double(longitudeStr) ?? 0.0
        }
        return location
    }
}

//
//  RWLocationManager.swift
//  RealWeather
//
//  Created by SangDon Kim on 27/03/2019.
//  Copyright © 2019 yapp. All rights reserved.
//

import Foundation
import CoreLocation

struct RWLocation {
    // 기본 위치 - 서울역
    var latitude: Double = 37.5533118
    var longitude: Double = 126.9689441
}

extension Notification.Name {
    static let UserLocationDidUpdated = Notification.Name("LocationDidUpdated")
}

class RWLocationManager: NSObject {
    static let shared = RWLocationManager()
    private let notification: NotificationCenter = NotificationCenter.default
    private let coreLocationManager = CLLocationManager()
    
    var currentLocation: RWLocation = RWLocation()
    
    override init() {
        super.init()
        coreLocationManager.delegate = self
        coreLocationManager.requestWhenInUseAuthorization()
        coreLocationManager.desiredAccuracy = kCLLocationAccuracyBest
        coreLocationManager.startUpdatingLocation()
    }
    
    func updateLocation() {
        coreLocationManager.startUpdatingLocation()
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
            notification.post(name: .UserLocationDidUpdated, object: nil)
            coreLocationManager.stopUpdatingLocation()
        }
    }
}

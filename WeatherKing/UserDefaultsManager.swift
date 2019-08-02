//
//  UserDefaultsManager.swift
//  WeatherKing
//
//  Created by SangDon Kim on 28/04/2019.
//  Copyright © 2019 yapp. All rights reserved.
//

import Foundation

public class UserDefaultsManager {
    public static let LastLoginMethod = AppDefaults<Int>(key: "LastLoginMethod", defaultValue: 4)
    public static let EverydayNotificationSetting = AppDefaults<Bool>(key: "EverydayNotificationSetting", defaultValue: true)
    public static let EverydayAMNotificaitonTime = AppDefaults<Double>(key: "EverydayAMNotificaitonTime", defaultValue: AppCommon.notificationDefaultAMTime)
    public static let EverydayPMNotificaitonTime = AppDefaults<Double>(key: "EverydayPMNotificaitonTime", defaultValue: AppCommon.notificationDefaultPMTime)
    public static let RainNotificationSetting = AppDefaults<Bool>(key: "RainNotificationSetting", defaultValue: true)
    public static let FineDustNotificationSetting = AppDefaults<Bool>(key: "FineDustNotificationSetting", defaultValue: true)
    public static let TemperatureUnitSetting = AppDefaults<Int>(key: "TemperatureUnitSetting", defaultValue: 0)
}

public class AppDefaults<T>: NSObject {
    private let key: String
    private let defaultValue: T
    
    public init(key: String, defaultValue: T) {
        self.key = key
        self.defaultValue = defaultValue
    }
    
    public func get() -> T {
        return UserDefaults.standard.object(forKey: key) as? T ?? defaultValue
    }
    
    public func set(_ value: T) {
        UserDefaults.standard.set(value, forKey: key)
    }
}

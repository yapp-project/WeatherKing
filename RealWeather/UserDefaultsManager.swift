//
//  UserDefaultsManager.swift
//  RealWeather
//
//  Created by SangDon Kim on 28/04/2019.
//  Copyright © 2019 yapp. All rights reserved.
//

import Foundation

public class UserDefaultsManager {
    public static let LastLoginMethod = AppDefaults<Int>(key: "LastLoginMethod", defaultValue: 4)
    public static let EverydayNotificationSetting = AppDefaults<Bool>(key: "EverydayNotificationSetting", defaultValue: true)
    public static let RainNotificationSetting = AppDefaults<Bool>(key: "RainNotificationSetting", defaultValue: true)
    public static let UltradustNotificationSetting = AppDefaults<Bool>(key: "UltradustNotificationSetting", defaultValue: true)
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

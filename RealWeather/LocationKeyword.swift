//
//  LocationKeyword.swift
//  RealWeather
//
//  Created by yoo on 2019. 5. 28..
//  Copyright © 2019년 yapp. All rights reserved.
//

import Foundation

class LocationKeyword {
    var location: [String] = []
    var longitude: [String] = []
    var latitude: [String] = []
    
    func LocationKeyword(_location: [String], longitude: [String], latitude: [String]) {
        self.location = _location
        self.longitude = longitude
        self.latitude = latitude
    }
}

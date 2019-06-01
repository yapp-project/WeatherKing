//
//  RWUser.swift
//  WeatherKing
//
//  Created by USER on 25/05/2019.
//  Copyright © 2019 yapp. All rights reserved.
//

import Foundation

class RWUser {
    let userID: String
    var uniqueID: String = ""
    let loginMethod: SignUpMethod
    var nickname: String = ""
    var location: RWLocation = RWLocation()
    var region: RWRegion = RWRegion()
    var salt: String = ""
    var _id: String = ""
    var __v: Int = 0
    
    init(userID: String, loginMethod: SignUpMethod) {
        self.userID = userID
        self.loginMethod = loginMethod
        
        location = RWLocationManager.shared.currentLocation
    }
}

class RWRegion {
    var cityName: String = ""
    var sidoName: String = ""
    var townName: String = ""
    var pos: String = ""
}

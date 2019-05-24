//
//  RWUser.swift
//  RealWeather
//
//  Created by USER on 25/05/2019.
//  Copyright © 2019 yapp. All rights reserved.
//

import Foundation

class RWUser {
    let uniqueID: String
    let loginMethod: SignUpMethod
    var nickname: String = ""
    var location: RWLocation = RWLocation()
    
    init(uniqueID: String, loginMethod: SignUpMethod) {
        self.uniqueID = uniqueID
        self.loginMethod = loginMethod
        
        location = LocationManager.shared.currentLocation
    }
}

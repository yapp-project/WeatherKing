//
//  RWNetworkManager.swift
//  WeatherKing
//
//  Created by USER on 01/06/2019.
//  Copyright © 2019 yapp. All rights reserved.
//

import Reachability

class RWNetworkManager {
    static let shared = RWNetworkManager()
    
    var reachability: Reachability?
    
    var isConnected: Bool {
        return status != .none
    }
    
    var status: Reachability.Connection {
        return reachability?.connection ?? .none
    }
    
    init() {
        reachability = Reachability()
    }
}

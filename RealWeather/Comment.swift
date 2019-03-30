//
//  Comment.swift
//  RealWeather
//
//  Created by sdondon on 23/02/2019.
//  Copyright © 2019 yapp. All rights reserved.
//

import UIKit

class Comment: NSObject {
    var name: String = ""
    var comment: String = ""
    var distance: Int = 0
    var time: Int = 0
    var goodCount: Int = 0
    var badCount: Int = 0
    
    init(name: String, comment: String, distance: Int, time: Int, goodCount: Int, badCount: Int) {
        self.name = name
        self.comment = comment
        self.distance = distance
        self.time = time
        self.goodCount = goodCount
        self.badCount = badCount
    }
    
    override init() {}
}

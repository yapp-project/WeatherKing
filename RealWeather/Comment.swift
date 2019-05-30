//
//  Comment.swift
//  RealWeather
//
//  Created by sdondon on 23/02/2019.
//  Copyright © 2019 yapp. All rights reserved.
//

import UIKit

class Comment: NSObject {
    var id: String = ""
    var name: String = ""
    var comment: String = ""
    var distance: Int = 0
    var time: Int = 0
    var likeCount: Int = 0
    var hateCount: Int = 0
    var isLike: Bool = false
    var isHate: Bool = false
    var uniqueId: String = ""
    
    init(name: String, comment: String, distance: Int, time: Int, likeCount: Int, hateCount: Int) {
        self.name = name
        self.comment = comment
        self.distance = distance
        self.time = time
        self.likeCount = likeCount
        self.hateCount = hateCount
    }
    
    override init() {}
}

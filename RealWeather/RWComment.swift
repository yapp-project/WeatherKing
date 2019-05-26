//
//  RWComment.swift
//  RealWeather
//
//  Created by sdondon on 23/02/2019.
//  Copyright © 2019 yapp. All rights reserved.
//

import UIKit

public class RWComment: NSObject {
    var userID: String = ""
    var nickname: String = ""
    var content: String = ""
    var timestamp: String = ""
    var expireAt: String = ""
    var distance: Int = 0
    var time: Int = 0
    var likeCount: Int = 0
    var hateCount: Int = 0
    var isLike: Bool = false
    var isHate: Bool = false
    
    init(nickname: String, content: String, distance: Int, time: Int, likeCount: Int, hateCount: Int) {
        self.nickname = nickname
        self.content = content
        self.distance = distance
        self.time = time
        self.likeCount = likeCount
        self.hateCount = hateCount
    }
    
    override init() {}
}

public extension Dictionary where Key: ExpressibleByStringLiteral, Value: Any {
    func parseComment() -> RWComment {
        let comment = RWComment()
        comment.userID = (self["_id"] as? String)?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        comment.nickname = (self["nickname"] as? String)?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        comment.content = (self["content"] as? String) ?? ""
        comment.timestamp = (self["timestamp"] as? String)?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        comment.likeCount = (self["like"] as? Int) ?? 0
        comment.hateCount = (self["dislike"] as? Int) ?? 0
        comment.expireAt = (self["expireAt"] as? String) ?? ""
        // comment.___v = (self["__v"] as? Int) ?? 0
        
        return comment
    }
}

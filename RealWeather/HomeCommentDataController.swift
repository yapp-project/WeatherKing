//
//  HomeCommentDataController.swift
//  RealWeather
//
//  Created by sdondon on 23/02/2019.
//  Copyright © 2019 yapp. All rights reserved.
//

import Foundation

enum CommentState: String {
    case like
    case dislike
    case cancelLike = "like/cancel"
    case cancelDisLike = "dislike/cancel"
}

enum Accuse: String {
    case abuse = "0"
    case advertise = "1"
    case unrelate = "2"
}

class HomeCommentDataController {
    private let requestor: RWApiRequest = RWApiRequest()
    
    func requestComment(completion: @escaping ([RWComment]?) -> Void) {
        guard let user = RWLoginManager.shared.user else { completion(nil); return }
        let queryItems: [URLQueryItem] = [URLQueryItem(name: "uid", value: user.uniqueID),
                                          URLQueryItem(name: "type", value: String(user.loginMethod.rawValue))]
        
        requestor.cancel()
        requestor.baseURLPath = "http://15.164.86.162:3000/api/board/list"
        requestor.method = .get
        requestor.fetch(with: queryItems) { [weak self] data, error in
            let completionInMainThread = { (completion: @escaping ([RWComment]?) -> Void, result: [RWComment]?) in
                DispatchQueue.main.async {
                    completion(result)
                }
            }
            
            guard let data = data, error == nil else {
                completionInMainThread(completion, nil)
                return
            }
            
            do {
                let list: [RWComment]? = try self?.parseComments(with: data)
                completionInMainThread(completion, list)
            } catch {
                completionInMainThread(completion, nil)
            }
        }
    }
    
    func writeComment(_ comment: String, completion: @escaping (Error?) -> Void) {
        guard let user = RWLoginManager.shared.user else { completion(nil); return }
        let queryItems: [URLQueryItem] = [URLQueryItem(name: "uid", value: user.uniqueID),
                                          URLQueryItem(name: "type", value: String(user.loginMethod.rawValue)), URLQueryItem(name: "nickname", value: user.nickname), URLQueryItem(name: "content", value: comment)]
        requestor.cancel()
        requestor.baseURLPath = "http://15.164.86.162:3000/api/board/write"
        requestor.method = .post
        requestor.fetch(with: queryItems, completion: { data, error in
            if data == nil, let error = error {
                DispatchQueue.main.async {
                    completion(error)
                }
                return
            }
            DispatchQueue.main.async {
                completion(nil)
            }
        })
    }
    
    
    func reactComment(_ id: String, state: CommentState, completion: @escaping (Data?) -> Void) {
        requestor.cancel()
        requestor.baseURLPath = "http://15.164.86.162:3000/api/board/" + state.rawValue + "/" + id
        requestor.method = .put
        requestor.fetch(with: [], completion: { data, error in
            DispatchQueue.main.async {
                completion(data)
            }
        })
    }
    
    func accuseComment(_ id: String, state: Accuse, completion: @escaping (Data?) -> Void) {
        requestor.cancel()
        requestor.baseURLPath = "http://15.164.86.162:3000/api/board/accusation/" + id + "/" + state.rawValue
        requestor.method = .put
        requestor.fetch(with: [], completion: { data, error in
            DispatchQueue.main.async {
                completion(data)
            }
        })
    }
    
    
    func removeComment(_ id: String, completion: @escaping (Data?) -> Void) {
        guard let user = RWLoginManager.shared.user else { completion(nil); return }
        let queryItems: [URLQueryItem] = [URLQueryItem(name: "id", value: id), URLQueryItem(name: "uid", value: user.uniqueID), URLQueryItem(name: "type", value: String(user.loginMethod.rawValue))]
        requestor.cancel()
        requestor.baseURLPath = "http://15.164.86.162:3000/api/board/removal"
        requestor.method = .delete
        requestor.fetch(with: queryItems, completion: { data, error in
            DispatchQueue.main.async {
                completion(data)
            }
        })
    }
    
    
    
}

extension HomeCommentDataController {
    private func parseComments(with data: Data?) throws -> [RWComment]? {
        guard let data = data, let jsons = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [[String: Any]] else {
            return nil
        }
        var commentList: [RWComment] = []
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        
        for item in jsons {
            let comment = RWComment()
            comment.nickname = item["nickname"] as? String ?? ""
            comment.content = item["content"] as? String ?? ""
            let time = item["timestamp"] as? String ?? ""
            let date = formatter.date(from: time)
            let interval = Date().timeIntervalSince(date ?? Date())
            if interval >= 3600 {
                comment.time = String(Int(floor(interval / 3600))) + "시간 전"
            }
            else {
                comment.time = String(Int(interval >= 0 ? floor(interval / 60) : 0)) + "분 전"
            }
            comment.interval = interval >= 0 ? interval : 0
            comment.likeCount = item["like"] as? Int ?? 0
            comment.hateCount = item["dislike"] as? Int ?? 0
            comment.userID = item["_id"] as? String ?? ""
            comment.uniqueID = item["uid"] as? String ?? ""
            commentList.append(comment)
        }
        
        print(jsons)
        return commentList
    }
    
}

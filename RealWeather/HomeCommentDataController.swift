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
    case report = "accusation"
}

class HomeCommentDataController {
    private let requestor: RWApiRequest = RWApiRequest()
    
    func requestComment(completion: @escaping ([Comment]?) -> Void) {
        let queryItems: [URLQueryItem] = [URLQueryItem(name: "uid", value: "dlflwjflehfdkeksu"),
                                          URLQueryItem(name: "type", value: "1")]
        
        requestor.cancel()
        requestor.baseURLPath = "http://15.164.86.162:3000/api/board/list"
        requestor.fetch(with: queryItems) { [weak self] data, error in
            let completionInMainThread = { (completion: @escaping ([Comment]?) -> Void, result: [Comment]?) in
                DispatchQueue.main.async {
                    completion(result)
                }
            }
            
            guard let data = data, error == nil else {
                completionInMainThread(completion, nil)
                return
            }
            
            do {
                let list: [Comment]? = try self?.parseComments(with: data)
                completionInMainThread(completion, list)
            } catch {
                completionInMainThread(completion, nil)
            }
        }
    }
    
    func setComment(_ comment: String, completion: @escaping (Error?) -> Void) {
        let queryItems: [URLQueryItem] = [URLQueryItem(name: "uid", value: "dlflwjflehfdkeksu"),
                                          URLQueryItem(name: "type", value: "1"), URLQueryItem(name: "nickname", value: "날씨왕"), URLQueryItem(name: "content", value: comment)]
        requestor.cancel()
        requestor.baseURLPath = "http://15.164.86.162:3000/api/board/write"
        requestor.method = .post
        requestor.fetch(with: queryItems, completion: { data, error in
            if data == nil, let error = error {
                completion(error)
                return
            }
            if data == nil {
                print("data는 nil")
            }
            
            DispatchQueue.main.async {
                completion(nil)
            }
        })
    }
    
    
    func reactComment(_ id: String, state: CommentState, completion: @escaping (Error?) -> Void) {
        requestor.cancel()
        requestor.baseURLPath = "http://15.164.86.162:3000/api/board/" + state.rawValue + "/" + id
        requestor.method = .put
        requestor.fetch(with: [], completion: { data, error in
            if data == nil, let error = error {
                completion(error)
                return
            }
            DispatchQueue.main.async {
                completion(nil)
            }
        })
    }
    
    func removeComment(_ id: String, completion: @escaping (Error?) -> Void) {
        let queryItems: [URLQueryItem] = [URLQueryItem(name: "id", value: id), URLQueryItem(name: "uid", value: "ee"), URLQueryItem(name: "type", value: "1")]
        requestor.cancel()
        requestor.baseURLPath = "http://15.164.86.162:3000/api/board/removal"
        requestor.method = .delete
        requestor.fetch(with: queryItems, completion: { data, error in
            if data == nil, let error = error {
                completion(error)
                return
            }
            DispatchQueue.main.async {
                completion(nil)
            }
        })
    }
    
    
    
}

extension HomeCommentDataController {
    private func parseComments(with data: Data?) throws -> [Comment]? {
        guard let data = data, let jsons = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [[String: Any]] else {
            return nil
        }
        var commentList: [Comment] = []
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        
        for item in jsons {
            //            for data in item as? [[String:Any]] ?? [[:]] {
            let comment = Comment()
            comment.name = item["nickname"] as? String ?? ""
            comment.comment = item["content"] as? String ?? ""
            let time = item["timestamp"] as? String ?? ""
            let date = formatter.date(from: time)
            let interval = Date().timeIntervalSince(date ?? Date())
            comment.time = Int(floor(interval / 60))
            comment.likeCount = item["like"] as? Int ?? 0
            comment.hateCount = item["dislike"] as? Int ?? 0
            comment.id = item["_id"] as? String ?? ""
            commentList.append(comment)
            //            }
        }
        
        print(jsons)
        return commentList
    }
    
}

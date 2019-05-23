//
//  HomeCommentDataController.swift
//  RealWeather
//
//  Created by sdondon on 23/02/2019.
//  Copyright © 2019 yapp. All rights reserved.
//

import Foundation

class HomeCommentDataController {
    private let requestor: RWApiRequest = RWApiRequest()
    
    func requestComment(completion: @escaping ([Comment]?) -> Void) {
        let queryItems: [URLQueryItem] = [URLQueryItem(name: "uid", value: "asdf8sda97f98ads7f98ads7f8sda7f98ad"),
        URLQueryItem(name: "type", value: "1"), URLQueryItem(name: "nickname", value: "신립5년차")]
        
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
        let queryItems: [URLQueryItem] = [URLQueryItem(name: "uid", value: "asdf8sda97f98ads7f98ads7f8sda7f98ad"),
                                          URLQueryItem(name: "type", value: "1"), URLQueryItem(name: "nickname", value: "신립5년차"), URLQueryItem(name: "content", value: comment)]
        requestor.cancel()
        requestor.baseURLPath = "http://15.164.86.162:3000/api/board/write"
        requestor.method = .post
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
    
    func likeComment(_ id: String, completion: @escaping (Error?) -> Void) {
        let queryItems: [URLQueryItem] = [URLQueryItem(name: "id", value: id)]
        requestor.cancel()
        requestor.baseURLPath = "http://15.164.86.162:3000/api/board/like"
        requestor.method = .put
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
    
    func hateComment(_ id: String, completion: @escaping (Error?) -> Void) {
        let queryItems: [URLQueryItem] = [URLQueryItem(name: "id", value: id)]
        requestor.cancel()
        requestor.baseURLPath = "http://15.164.86.162:3000/api/board/dislike"
        requestor.method = .put
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
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        
        for item in jsons {
            for data in item["list"] as? [[String:Any]] ?? [[:]] {
                let comment = Comment()
                comment.name = data["nickname"] as? String ?? ""
                comment.comment = data["content"] as? String ?? ""
                let time = data["timestamp"] as? String ?? ""
                let date = formatter.date(from: time)
                let interval = Date().timeIntervalSince(date ?? Date())
                comment.time = Int(floor(interval / 60))
                comment.likeCount = data["like"] as? Int ?? 0
                comment.hateCount = data["dislike"] as? Int ?? 0
                commentList.append(comment)
            }
        }
        
        print(jsons)
        return commentList
    }
}

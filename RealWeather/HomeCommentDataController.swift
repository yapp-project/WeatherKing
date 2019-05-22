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
//        let queryItems: [URLQueryItem] = [URLQueryItem(name: "postId", value: "1")]
        let queryItems: [URLQueryItem] = [URLQueryItem(name: "uid", value: "asdf8sda97f98ads7f98ads7f8sda7f98ad"),
        URLQueryItem(name: "type", value: "1"), URLQueryItem(name: "nickname", value: "신립5년차")]
        
        requestor.cancel()
//        requestor.baseURLPath = "https://jsonplaceholder.typicode.com/comments"
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
    
    func setComment(_ comment: String, completion: @escaping () -> Void) {
        let queryItems: [URLQueryItem] = [URLQueryItem(name: "uid", value: "asdf8sda97f98ads7f98ads7f8sda7f98ad"),
                                          URLQueryItem(name: "type", value: "1"), URLQueryItem(name: "nickname", value: "신립5년차"), URLQueryItem(name: "content", value: comment)]
        requestor.cancel()
        requestor.baseURLPath = "http://15.164.86.162:3000/api/board/write"
        requestor.method = .post
        requestor.fetch(with: queryItems, completion: { data, error in
            
        })
        
        completion()
    }
    
    func likeComment(_ comment: Comment, completion: @escaping () -> Void) {
        requestor.cancel()
        requestor.baseURLPath = "http://15.164.86.162:3000/api/board/like"
        requestor.method = .put
        
        
        completion()
    }
    
    
    
}

extension HomeCommentDataController {
    private func parseComments(with data: Data?) throws -> [Comment]? {
        guard let data = data, let jsons = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [[String: Any]] else {
            return nil
        }
        var commentList: [Comment] = []
        
        for item in jsons {
            for data in item["list"] as? [[String:Any]] ?? [[:]] {
                let comment = Comment()
                comment.name = data["nickname"] as? String ?? ""
                comment.comment = data["content"] as? String ?? ""
                comment.time = Int(data["timestamp"] as? String ?? "") ?? 0
                comment.likeCount = data["like"] as? Int ?? 0
                comment.hateCount = data["dislike"] as? Int ?? 0
                commentList.append(comment)
            }
        }
        
        print(jsons)
        return commentList
    }
}

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
    
    func requestData(completion: @escaping (RWComment?) -> Void) {
        let queryItems: [URLQueryItem] = [URLQueryItem(name: "postId", value: "1")]
        
        requestor.cancel()
        requestor.baseURLPath = "https://jsonplaceholder.typicode.com/comments"
        requestor.fetch(with: queryItems) { [weak self] data, error in
            let completionInMainThread = { (completion: @escaping (RWComment?) -> Void, result: RWComment?) in
                DispatchQueue.main.async {
                    completion(result)
                }
            }
            
            guard let data = data, error == nil else {
                completionInMainThread(completion, nil)
                return
            }
            
            do {
                let comment: RWComment? = try self?.parseComments(with: data)
                completionInMainThread(completion, comment)
            } catch {
                completionInMainThread(completion, nil)
            }
        }
    }
    
    func setComment(_ comment: RWComment, completion: @escaping () -> Void) {
        completion()
    }
}

extension HomeCommentDataController {
    private func parseComments(with data: Data?) throws -> RWComment? {
        guard let data = data, let jsons = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [[String: Any]] else {
            return nil
        }
        
        print(jsons)
        return RWComment()
    }
}

//
//  RWApiRequest.swift
//  RealWeather
//
//  Created by sdondon on 23/02/2019.
//  Copyright © 2019 YAPP. All rights reserved.
//

import Foundation

public enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case delete = "DELETE"
    case put = "PUT"
}

public typealias RWApiResult = (_ data: Data?, _ error: Error?) -> Void

public enum RWApiResponse {
    case success(Int)
    case clientError(Int)
    case serverError(Int)
    case retryRequired(Int)
    
    init(from urlResponse: URLResponse?) {
        let statusCode = (urlResponse as? HTTPURLResponse)?.statusCode ?? 500
        
        switch statusCode {
        case 200..<300:
            self = .success(statusCode)
        case 429, 503, 504:
            self = .retryRequired(statusCode)
        case 400..<500:
            self = .clientError(statusCode)
        default:
            self = .serverError(statusCode)
        }
    }
}

public class RWApiRequest {
    enum Constant {
        static let maximumRetryCount: Int = 3
    }
    
    public var baseURLPath: String = ""
    public let urlSession = URLSession.shared
    public let timeout: TimeInterval = 10.0
    public var method: HTTPMethod = .get
    
    fileprivate var dataTask: URLSessionTask?
    fileprivate var retryCount: Int = 0
}

extension RWApiRequest {
    public func fetch(with queryItems: [URLQueryItem], completion: @escaping RWApiResult) {
        guard var urlComponents = URLComponents(string: baseURLPath) else {
            completion(nil, nil)
            return
        }
        
        urlComponents.queryItems = queryItems
        
        guard let url = urlComponents.url else {
            completion(nil, nil)
            return
        }
        
        var request: URLRequest = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.timeoutInterval = timeout
        // TODO: 리얼 API 연결 시 제거
        request.cachePolicy = .reloadIgnoringCacheData
        
        if method != .get {
            var queryComponents: URLComponents = URLComponents()
            queryComponents.queryItems = queryItems
            request.httpBody = queryComponents.url?.path.data(using: String.Encoding.ascii, allowLossyConversion: true)
        }
        
        fetch(with: request, completion: completion)
    }
}

extension RWApiRequest {
    public func fetch(with request: URLRequest, completion: @escaping RWApiResult) {
        dataTask = urlSession.dataTask(with: request) { [weak self] data, response, error in
            guard error == nil else {
                completion(nil, error)
                return
            }
            
            let response: RWApiResponse = RWApiResponse(from: response)
            switch response {
            case .success:
                completion(data, nil)
            case .retryRequired:
                self?.retry(of: request, error: error, completion: completion)
            case .clientError, .serverError:
                completion(nil, error)
            }
            
            self?.retryCount = 0
        }
        dataTask?.resume()
    }
  
    private func retry(of request: URLRequest, error: Error?, completion: @escaping RWApiResult) {
        guard retryCount < Constant.maximumRetryCount else {
            completion(nil, error)
            return
        }
        
        retryCount += 1
        fetch(with: request, completion: completion)
    }
    
    public func cancel() {
        dataTask?.cancel()
    }
}

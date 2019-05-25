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
        
        if method == .get {
            urlComponents.queryItems = queryItems
        }
        
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
            
            if var httpBody = queryComponents.url?.absoluteString {
                if httpBody.first == "?" {
                    httpBody.removeFirst()
                }
                request.httpBody = httpBody.data(using: String.Encoding.ascii, allowLossyConversion: true)
            }
        }
        fetch(with: request, completion: completion)
    }
}

extension RWApiRequest {
    public func fetch(with request: URLRequest, completion: @escaping RWApiResult) {
        dataTask = urlSession.dataTask(with: request) { [weak self] data, serverResponse, error in
            do {
                try self?.printServerResponse(data, error: error)
            } catch {
                print("wtf")
            }
            
            guard error == nil else {
                completion(nil, error)
                return
            }

            let response: RWApiResponse = RWApiResponse(from: serverResponse)
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
    
    private func printServerResponse(_ data: Data?, error: Error?) throws {
        guard let data = data, let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] else {
            AppCommon.dprint("[Reponse] error: \(error?.localizedDescription ?? "")")
            return
        }
        
        let status: Int = (json["status"] as? Int) ?? 1300
        let code: Int = (json["code"] as? Int) ?? 0
        let message: String = (json["message"] as? String) ?? "no message"
        let description: String = (json["description"] as? String) ?? "no description"
        AppCommon.dprint("[Reponse] status: \(status), code: \(code), message: \(message), description: \(description), error: \(error?.localizedDescription ?? "no error")")
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

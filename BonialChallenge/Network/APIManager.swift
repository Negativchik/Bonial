//
//  APIManager.swift
//  BonialChallenge
//
//  Created by Michael Smirnov on 26.09.16.
//  Copyright © 2016 Smirnov. All rights reserved.
//

import Foundation

enum APIManagerError: Error {
    case wrongURL
}

typealias DataTaskCompletionClosure = (Data?, URLResponse?) -> ()
typealias DataTaskFailureClosure = (URLResponse?, Error) -> ()

class APIManager {
    
    // MARK: Public
    
    public var urlString: String!
    // currentDataTask keeps current task to have ability to cancel it
    var currentDataTask: URLSessionDataTask?
    
    // MARK: Private
    
    private var session: URLSession
    private let defaultURLString = "https://dl.dropboxusercontent.com/u/41357788/coding_task/api.json"
    // Converts urlString to URL object
    private var url: URL? {
        return URL(string: urlString)
    }
    
    // MARK: - Init/deinit
    
    convenience init() {
        self.init(urlString: nil)
    }
    
    init(urlString string: String?) {
        let configuration = URLSessionConfiguration.ephemeral
        self.session = URLSession(configuration: configuration)
        
        urlString = string ?? defaultURLString
    }
    
    deinit {
        session.invalidateAndCancel()
    }
    
    // MARK: Data load stuff
    
    /// loadData loads JSON object from url
    @discardableResult
    func loadData(completion: @escaping DataTaskCompletionClosure, failure: DataTaskFailureClosure?) -> URLSessionDataTask? {
        guard let url = url else {
            failure?(nil, APIManagerError.wrongURL)
            return nil
        }
        
        currentDataTask?.cancel()
        
        var request = URLRequest(url: url, cachePolicy: .reloadIgnoringCacheData, timeoutInterval: 10.0)
        request.httpMethod = "GET"
        
        let task = session.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            self.currentDataTask = nil
            if let error = error {
                debugPrint(error.localizedDescription)
                if (error as NSError).code != NSURLErrorCancelled {
                    // not cancelled - some other error
                    failure?(response, error)
                }
            } else {
                completion(data, response)
            }
        }
        task.resume()
        currentDataTask = task
        
        return task
    }
    
    func cancelCurrentTask() {
        currentDataTask?.cancel()
    }
    
}

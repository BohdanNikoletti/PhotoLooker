//
//  NetworkRequest.swift
//  PhotoLooker
//
//  Created by Bohdan Mihiliev on 30.09.17.
//  Copyright © 2017 Bohdan Mihiliev. All rights reserved.
//

import Foundation

protocol NetworkRequest: class {
    associatedtype Model
    func load(withCompletion completion: @escaping (Model?) -> ())
    func decode(_ data: Data) -> Model?
}

extension NetworkRequest {
    
    func load(_ url: URL, authHeader: [String: String]? = nil,
              withCompletion completion: @escaping (Model?) -> ()) {
        let configuration = URLSessionConfiguration.ephemeral
        if let header = authHeader{
            configuration.httpAdditionalHeaders = header 
        }
        let session = URLSession(configuration: configuration, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: url, completionHandler: {
            [weak self] (data: Data?, response: URLResponse?, error: Error?) in
            if let error = error {
                print("Server Error: \(error.localizedDescription)")
                completion(nil)
                return
            }
            guard let data = data else {
                completion(nil)
                return
            }
            completion(self?.decode(data))
        })
        task.resume()
    }
}

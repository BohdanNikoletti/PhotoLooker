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
// MARK: - Public methods extension
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
      #if DEBUG
      self?.deBugPrintJson(data)
      #endif
      completion(self?.decode(data))
    })
    task.resume()
  }
  
  func deBugPrintJson(_ data: Data) {
    do {
      let jsonData = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
      print(jsonData ?? "JSON data is Empty")
      
    } catch {
      print(error.localizedDescription)
    }
  }
}

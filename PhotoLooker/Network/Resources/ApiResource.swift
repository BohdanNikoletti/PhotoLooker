//
//  ApiResource.swift
//  PhotoLooker
//
//  Created by Bohdan Mihiliev on 30.09.17.
//  Copyright © 2017 Bohdan Mihiliev. All rights reserved.
//

import Foundation

protocol ApiResource {
  associatedtype Model
  
  var methodPath: String { get }
  var searchPhrase: String { get }
  var page: Int { get }
  
  func makeModel(data: Data) -> [Model]?
}

// MARK: - Computed properties
extension ApiResource {
  
  var url: URL {
    var urlComponents = URLComponents()
    urlComponents.scheme = "https"
    urlComponents.host = APIEndpoints.host
    urlComponents.path = "/v3/search\(methodPath)"
    
    let fieldsQuery = URLQueryItem(name: "fields", value: "id,title,thumb")
    let sortQuery = URLQueryItem(name: "sort_order", value: "best")
    let phraseQuery = URLQueryItem(name: "phrase", value: searchPhrase)
    let pageQuery = URLQueryItem(name: "page", value: "\(page)")

    urlComponents.queryItems = [fieldsQuery, sortQuery, phraseQuery, pageQuery]
    
    return urlComponents.url.unsafelyUnwrapped
  }
  
  var decoder: JSONDecoder {
    return JSONDecoder()
  }
}

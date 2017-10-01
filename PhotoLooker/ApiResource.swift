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
    var methodPath: String {get}
    var searchPhrase: String {get}
    func makeModel(serialization:  [String: Any]) -> Model?
}

extension ApiResource {
    
    var url: URL{
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "api.gettyimages.com"
        urlComponents.path = "/v3/search\(methodPath)"
        
        let fieldsQuery = URLQueryItem(name: "fields", value: "id,title,thumb")
        let sortQuery = URLQueryItem(name: "sort_order", value: "best")
        let phraseQuery = URLQueryItem(name: "phrase", value: searchPhrase)
        
        urlComponents.queryItems = [fieldsQuery, sortQuery,phraseQuery]
        
        return urlComponents.url!
    }
    
    func makeModel(data: Data) ->[Model]? {
        guard let json = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) else {return nil}
        let jsonObj = json as? [String: Any]
        let jsonArray = jsonObj?["images"] as? [[String: Any]]
        return jsonArray?.map {
            makeModel(serialization: $0)!
        }
    }
}

struct ImageResource: ApiResource {
    
    var searchPhrase: String
    let methodPath = "/images"
    
    init(searchTo phrase: String){
        self.searchPhrase = phrase
    }
    
    func makeModel(serialization:  [String: Any]) -> ImageItem? {
        return ImageItem(withJsonObject: serialization)
    }
}

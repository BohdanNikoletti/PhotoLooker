//
//  ApiRequest.swift
//  PhotoLooker
//
//  Created by Bohdan Mihiliev on 30.09.17.
//  Copyright © 2017 Bohdan Mihiliev. All rights reserved.
//

import Foundation

class ApiRequest<Resource: ApiResource>{
    
    let resource: Resource
    init(resource: Resource) {
        self.resource = resource
    }
    
}
extension  ApiRequest: NetworkRequest {
    
    func decode(_ data: Data) -> [Resource.Model]? {
        return resource.makeModel(data: data)
    }
    
    func load(withCompletion completion: @escaping ([Resource.Model]?) -> Void) {
        load(resource.url, authHeader: ["Api-Key": "pesprtpumxqpqzsv6q37kn8s"], withCompletion: completion)
    }
    
}

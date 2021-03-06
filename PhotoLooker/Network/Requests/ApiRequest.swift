//
//  ApiRequest.swift
//  PhotoLooker
//
//  Created by Bohdan Mihiliev on 30.09.17.
//  Copyright © 2017 Bohdan Mihiliev. All rights reserved.
//

import Foundation

class ApiRequest<Resource: ApiResource> {
  // MARK: - Properties
  let resource: Resource
  
  // MARK: - Initializers
  init(resource: Resource) {
    self.resource = resource
  }
  
}
extension  ApiRequest: NetworkRequest {
  
  func decode(_ data: Data) -> [Resource.Model]? {
    return resource.makeModel(data: data)
  }
  
  func load(withCompletion completion: @escaping ([Resource.Model]?) -> Void) {
    load(resource.url, authHeader: ["Api-Key": "3uzbn7xfgxc7gegnpetpp7k9"], withCompletion: completion)
  }
  
}
